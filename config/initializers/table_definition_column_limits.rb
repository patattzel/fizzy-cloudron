# Apply MySQL-compatible column limits when defining tables.
#
# For string columns: defaults to 255 (MySQL's VARCHAR default)
#
# For text columns: converts MySQL's `size:` option to equivalent limits:
#   - (blank/default): 65,535 (TEXT)
#   - size: :tiny: 255 (TINYTEXT)
#   - size: :medium: 16,777,215 (MEDIUMTEXT)
#   - size: :long: 4,294,967,295 (LONGTEXT)
#
# This ensures the SQLite schema records the same limits as MySQL,
# which the ColumnLimits validation concern uses to enforce limits.

module TableDefinitionColumnLimits
  TEXT_SIZE_TO_LIMIT = {
    tiny: 255,
    medium: 16_777_215,
    long: 4_294_967_295
  }.freeze

  TEXT_DEFAULT_LIMIT = 65_535
  STRING_DEFAULT_LIMIT = 255

  def column(name, type, **options)
    if type == :string
      options[:limit] ||= STRING_DEFAULT_LIMIT
    end

    if type == :text
      if options.key?(:size)
        size = options.delete(:size)
        options[:limit] ||= TEXT_SIZE_TO_LIMIT.fetch(size) do
          raise ArgumentError, "Unknown text size: #{size.inspect}. Use :tiny, :medium, or :long"
        end
      else
        options[:limit] ||= TEXT_DEFAULT_LIMIT
      end
    end

    super
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::ConnectionAdapters::TableDefinition.prepend(TableDefinitionColumnLimits)
end

ActiveSupport.on_load(:action_text_rich_text) do
  include ColumnLimits
end

ActiveSupport.on_load(:active_storage_blob) do
  include ColumnLimits
end

ActiveSupport.on_load(:active_storage_attachment) do
  include ColumnLimits
end
