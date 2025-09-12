class MigrateEverythingAcccessesToWatching < ActiveRecord::Migration[8.1]
  def up
    execute <<-SQL
      UPDATE accesses#{' '}
      SET involvement = 'watching'#{' '}
      WHERE involvement = 'everything'
    SQL
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
