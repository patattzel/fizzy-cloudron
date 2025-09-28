module Collection::Triageable
  extend ActiveSupport::Concern

  DEFAULT_COLUMNS = [
    { name: "Figuring it out", color: "var(--color-card-5)" },
    { name: "In progress", color: "var(--color-card-3)" }
  ]

  included do
    has_many :columns, dependent: :destroy

    after_create_commit :create_default_columns
  end

  private
    def create_default_columns
      Column.insert_all(DEFAULT_COLUMNS.map { { name: it[:name], color: it[:color], collection_id: id } })
    end
end
