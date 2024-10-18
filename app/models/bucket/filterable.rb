module Bucket::Filterable
  attr_accessor :tag_filters, :assignee_filters

  def filtered_bubbles(params = {})
    result = bubbles
    result = result.ordered_by(params["order_by"] || Bubble.default_order_by)
    result = result.with_status(params["status"] || Bubble.default_status)
    result = result.tagged_with(self.tag_filters) if set_tag_filters(params["tag_ids"])
    result = result.assigned_to(self.assignee_filters) if set_assignee_filters(params["assignee_ids"])
    result = result.mentioning(params["term"]) if params["term"]
    result
  end

  private
    def set_tag_filters(tag_ids)
      if tag_ids
        self.tag_filters = account.tags.where id: tag_ids
      end
    end

    def set_assignee_filters(assignee_ids)
      if assignee_ids
        self.assignee_filters = account.users.where id: assignee_ids
      end
    end
end
