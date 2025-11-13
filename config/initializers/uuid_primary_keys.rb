# Automatically use UUID type for all binary(16) columns
ActiveSupport.on_load(:active_record) do
  module MysqlUuidAdapter
    def lookup_cast_type(sql_type)
      if sql_type == "varbinary(16)"
        ActiveRecord::Type.lookup(:uuid, adapter: :trilogy)
      else
        super
      end
    end
  end

  ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter.prepend(MysqlUuidAdapter)

  # Fix schema dumper to include limit for binary columns
  module SchemaDumperBinaryLimit
    def prepare_column_options(column)
      spec = super
      # Ensure binary columns with limits always include them in schema
      if column.type == :binary && column.sql_type =~ /varbinary\((\d+)\)/
        spec[:limit] = $1.to_i
      end
      spec
    end
  end

  ActiveRecord::ConnectionAdapters::MySQL::SchemaDumper.prepend(SchemaDumperBinaryLimit)

  # Automatically convert :uuid to binary(16) for primary keys and columns
  module TableDefinitionUuidSupport
    def set_primary_key(table_name, id, primary_key, **options)
      # Convert :uuid to :binary with limit 16
      if id == :uuid
        id = :binary
        options[:limit] = 16
      elsif id.is_a?(Hash) && id[:type] == :uuid
        id[:type] = :binary
        id[:limit] = 16
      end

      super
    end

    def column(name, type, **options)
      # Convert :uuid to :binary with limit 16 for regular columns too
      if type == :uuid
        type = :binary
        options[:limit] = 16
      end

      super
    end

    # Define uuid as a column type method (like string, integer, etc.)
    def uuid(name, **options)
      column(name, :uuid, **options)
    end
  end

  ActiveRecord::ConnectionAdapters::TableDefinition.prepend(TableDefinitionUuidSupport)
end
