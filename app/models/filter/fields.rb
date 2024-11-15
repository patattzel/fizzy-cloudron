module Filter::Fields
  extend ActiveSupport::Concern

  INDEXES = %w[ most_discussed most_boosted newest oldest popped ]

  class_methods do
    def default_fields
      { indexed_by: "most_active" }
    end
  end

  included do
    store_accessor :fields, :indexed_by, :assignments, :terms

    def indexed_by
      (super || default_indexed_by).inquiry
    end

    def assignments
      super.to_s.inquiry
    end

    def terms
      Array(super)
    end
  end

  def default_indexed_by
    default_fields[:indexed_by]
  end

  def default_indexed_by?
    indexed_by == default_indexed_by
  end

  private
    delegate :default_fields, to: :class, private: true
end
