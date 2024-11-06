module Filter::Params
  extend ActiveSupport::Concern

  KNOWN_PARAMS = [ :indexed_by, :assignments, bucket_ids: [], assignee_ids: [], tag_ids: [] ]
  INDEXES = %w[ most_active most_discussed most_boosted newest oldest popped ]

  class_methods do
    def default_params
      { "indexed_by" => "most_active" }
    end
  end

  included do
    before_validation :sanitize_params
  end

  def to_params
    params.merge(tag_ids: tags.ids.presence, assignee_ids: assignees.ids.presence, bucket_ids: buckets.ids.presence).then do |params|
      ActionController::Parameters.new(params).permit(*KNOWN_PARAMS).tap do |params|
        params[:filter_id] = id if persisted?
      end
    end
  end

  def assignments=(value)
    params["assignments"] = value
  end

  def assignments
    params["assignments"].to_s.inquiry
  end

  def indexed_by=(value)
    params["indexed_by"] = value
  end

  def indexed_by
    (params["indexed_by"] || default_params["indexed_by"]).inquiry
  end

  private
    delegate :default_params, to: :class, private: true

    def sanitize_params
      denormalize_resource_ids
      self.params = non_default_params
      params.compact_blank!
    end

    def non_default_params
      params.reject { |k, v| default_params[k] == v }
    end
end
