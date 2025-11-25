# Apply MySQL-compatible column limits when using SQLite.
#
# For string columns: defaults to 255 (MySQL's VARCHAR default)
#
# For text columns: converts MySQL's `size:` option to equivalent limits:
#   - (blank/default): 65,535 (TEXT)
#   - size: :tiny: 255 (TINYTEXT)
#   - size: :medium: 16,777,215 (MEDIUMTEXT)
#   - size: :long: 4,294,967,295 (LONGTEXT)

module TableDefinitionColumnLimits
  # Map MySQL size options to limits
  TEXT_SIZE_TO_LIMIT = {
    tiny: 255,             # TINYTEXT
    medium: 16_777_215,    # MEDIUMTEXT
    long: 4_294_967_295    # LONGTEXT
  }.freeze

  TEXT_DEFAULT_LIMIT = 65_535   # TEXT
  STRING_DEFAULT_LIMIT = 255    # VARCHAR

  def column(name, type, **options)
    if type == :string
      options[:limit] ||= STRING_DEFAULT_LIMIT
    end

    if type == :text
      if options.key?(:size)
        size = options.delete(:size)
        options[:limit] = TEXT_SIZE_TO_LIMIT.fetch(size) do
          raise ArgumentError, "Unknown text size: #{size.inspect}. Use :tiny, :medium, or :long"
        end
      elsif options.key?(:limit)
        valid_limits = [TEXT_DEFAULT_LIMIT] + TEXT_SIZE_TO_LIMIT.values
        unless valid_limits.include?(options[:limit])
          raise ArgumentError, "Invalid limit #{options[:limit]} for text column. Use `size:` (:tiny, :medium, :long) or omit for default TEXT."
        end
      else
        options[:limit] = TEXT_DEFAULT_LIMIT
      end
    end

    super
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::ConnectionAdapters::TableDefinition.prepend(TableDefinitionColumnLimits)
end
