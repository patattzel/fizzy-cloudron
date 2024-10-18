class Bucket::BubbleFilter
  attr_reader :tags, :assignees

  def initialize(bucket, params = {})
    @bucket, @status, @order_by, @term = bucket, params["status"], params["order_by"], params["term"]
    @tags = find_tags(params["tag_ids"]) if params["tag_ids"]
    @assignees = find_assignees(params["assignee_ids"]) if params["assignee_ids"]
  end

  def bubbles
    @bubbles ||= begin
      result = bucket.bubbles
      result = result.ordered_by(order_by || Bubble.default_order_by)
      result = result.with_status(status || Bubble.default_status)
      result = result.tagged_with(tags) if tags
      result = result.assigned_to(assignees) if assignees
      result = result.mentioning(term) if term
      result
    end
  end

  private
    attr_reader :bucket, :status, :order_by, :term
    delegate :account, to: :bucket, private: true

    def find_tags(tag_ids)
      account.tags.where id: tag_ids
    end

    def find_assignees(assignee_ids)
      account.users.where id: assignee_ids
    end
end
