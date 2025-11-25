# Validates string and text column lengths to match MySQL limits.
# SQLite doesn't enforce column limits, so we need validations to ensure
# data portability between databases.
#
# Usage:
#   class Card < ApplicationRecord
#     include ColumnLimits
#   end
#
# This will automatically add length validations for all string and text
# columns based on their defined limits in the database schema.
#
# MySQL VARCHAR limits are in characters, not bytes.
# MySQL TEXT limits are in bytes.

module ColumnLimits
  extend ActiveSupport::Concern

  included do
    validate :validate_column_limits
  end

  private
    def validate_column_limits
      self.class.columns.each do |column|
        next unless column.limit
        next unless %i[string text].include?(column.type)

        value = read_attribute(column.name)
        next if value.nil?
        next unless value.is_a?(String)

        if column.type == :string
          # VARCHAR limits are in characters
          if value.length > column.limit
            errors.add(column.name, "is too long (maximum is #{column.limit} characters)")
          end
        else
          # TEXT limits are in bytes
          if value.bytesize > column.limit
            errors.add(column.name, "is too long (maximum is #{column.limit} bytes)")
          end
        end
      end
    end
end
