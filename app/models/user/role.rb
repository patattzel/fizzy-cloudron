module User::Role
  extend ActiveSupport::Concern

  included do
    enum :role, %i[ member system ].index_by(&:itself), scopes: false

    scope :member, -> { where(role: :member) }
    scope :without_system, -> { where.not(role: :system) }
    scope :active, -> { without_system.where(active: true) }
  end

  class_methods do
    def system
      find_or_create_by!(role: :system) do |user|
        user.name = "System"
      end
    end
  end
end
