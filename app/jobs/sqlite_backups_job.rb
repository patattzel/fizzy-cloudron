require "find"

#
#  This job backs up all the tenant databases using the SQLite Backup API, which should allow the
#  application to continue running against the database while it is backed up.
#
#  ref: https://www.sqlite.org/c3ref/backup_finish.html
#
#  It will keep N files around, like this:
#
#    storage/tenants/development/12345678/db/
#    ├─ main.sqlite3
#    ├─ main.sqlite3.1
#    ├─ main.sqlite3.2
#    ├─ main.sqlite3.3
#    ├─ main.sqlite3.4
#    └─ main.sqlite3.5
#
#  On some systems, notably in production, we have an NFS-mounted filesystem into which the
#  application copies the backup files for disaster recovery. We copy into an environment- and
#  tenant-specific directory. The file, when copied, will be renamed with the timestamp of the file
#  creation time. For example:
#
#    /backups/production/12345678/main.sqlite3.20251014194804
#
#  It will also clean up old backups in the NFS-mounted filesystem following our data retention policy.
#
class SQLiteBackupsJob < ApplicationJob
  DEFAULT_NUMBER_OF_BACKUPS = 5
  DEFAULT_STEP_PAGES = 1024
  DEFAULT_SWEEP_DIR = "/backups"
  DEFAULT_SWEEP_RETENTION = 30.days # https://37signals.com/policies/privacy

  def perform(keep: DEFAULT_NUMBER_OF_BACKUPS, step: DEFAULT_STEP_PAGES, sweep_dir: DEFAULT_SWEEP_DIR, sweep_retention: DEFAULT_SWEEP_RETENTION)
    @failures = []

    ApplicationRecord.with_each_tenant do |tenant|
      perform_file_rollover(tenant, keep:)
      perform_backup(tenant, step:)
      perform_sweep(tenant, sweep_dir:)
      enforce_retention(tenant, sweep_dir:, sweep_retention:)
    end

    if @failures.present?
      raise "SQLiteBackupsJob: failed to backup tenants: #{@failures.join(", ")}"
    end
  end

  private
    def perform_file_rollover(tenant, keep:)
      keep.downto(2) do |j|
        fresher = backup_path(tenant, j - 1)
        staler = backup_path(tenant, j)

        if j == keep && File.exist?(staler)
          FileUtils.rm(staler)
        end

        if File.exist?(fresher)
          # TODO: It may be worth benchmarking whether backing up into the previous backup is faster
          # than backing up into an empty file.
          FileUtils.mv(fresher, staler)
        end
      end
    end

    def perform_backup(tenant, step:)
      ApplicationRecord.with_connection do |conn|
        current_adapter = conn.raw_connection
        backup_db = backup_path(tenant, 1)
        backup_adapter = SQLite3::Database.new(backup_db)
        backup = SQLite3::Backup.new(backup_adapter, "main", current_adapter, "main")

        pages = 0
        elapsed = ActiveSupport::Benchmark.realtime(:float_millisecond) do
          loop do
            status = backup.step(step)
            case status
            when SQLite3::Constants::ErrorCode::DONE
              break
            when SQLite3::Constants::ErrorCode::OK
              total = backup.pagecount
              progress = total - backup.remaining
              log(tenant, :debug) { "Wrote #{progress} of #{total} pages." }
            when SQLite3::Constants::ErrorCode::BUSY, SQLite3::Constants::ErrorCode::LOCKED
              log(tenant, :debug) { "Busy, retrying." }
            else
              log(tenant, :error) { "Failed with status #{status}." }
              @failures << tenant
            end
          end

          pages = backup.pagecount
          backup.finish
        end

        log(tenant) { sprintf("Backup complete in %<elapsed>.1f ms. Wrote %{pages} pages to %{path}", path: backup_db.inspect, pages: pages, elapsed: elapsed) }
      end
    end

    def perform_sweep(tenant, sweep_dir:)
      unless File.directory?(sweep_dir) && File.writable?(sweep_dir)
        log(tenant, :warn) { "Skipping sweep, #{sweep_dir.inspect} does not exist or is not writable." }
        return
      end

      backup_file = backup_path(tenant, 1)
      sweep_path = File.join(sweep_dir, Rails.env, tenant)
      FileUtils.mkdir_p(sweep_path)

      if File.exist?(backup_file)
        timestamp = File.ctime(backup_file).utc.strftime("%Y%m%d%H%M%S")
        swept_file = File.join(sweep_path, File.basename(db_path(tenant)) + ".#{timestamp}")
        FileUtils.cp(backup_file, swept_file)
        log(tenant) { "Swept backup to #{swept_file.inspect}." }
      else
        log(tenant, :warn) { "No backup file found at #{backup_file.inspect} to sweep." }
      end
    end

    def enforce_retention(tenant, sweep_dir:, sweep_retention:)
      unless File.directory?(sweep_dir) && File.writable?(sweep_dir)
        log(tenant, :warn) { "Skipping retention enforcement, #{sweep_dir.inspect} does not exist or is not writable." }
        return
      end

      sweep_path = File.join(sweep_dir, Rails.env, tenant)
      if File.directory?(sweep_path)
        cutoff_time = Time.now - sweep_retention
        Find.find(sweep_path) do |path|
          if File.file?(path) && File.ctime(path) < cutoff_time
            FileUtils.rm(path)
            log(tenant) { "Removed old swept backup #{path.inspect}." }
          end
        end
      end
    end

    def backup_path(tenant, index)
      db_path(tenant) + ".#{index}"
    end

    def db_path(tenant)
      db_config.config_adapter.database_path
    end

    def db_config
      ApplicationRecord.connection_pool.db_config
    end

    def log(tenant, level = :info, &block)
      message = block.call
      Rails.logger.send(level, "[tenant=#{tenant}] SQLiteBackupsJob: #{message}")
    end
end
