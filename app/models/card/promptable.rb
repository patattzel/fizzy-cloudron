module Card::Promptable
  extend ActiveSupport::Concern

  MAX_COMMENTS = 10

  included do
    include Rails.application.routes.url_helpers
  end

  def to_prompt
    <<~PROMPT
      BEGIN OF CARD #{id}

      **Title:** #{title}
      **Description:**

      #{description.to_plain_text}

      #### Metadata

      * Id: #{id}
      * Created by: #{creator.name}}
      * Assigned to: #{assignees.map(&:name).join(", ")}}
      * Created at: #{created_at}}
      * Closed: #{closed?}
      * Closed by: #{closed_by&.name}
      * Closed at: #{closed_at}
      * Collection id: #{collection_id}
      * Collection name: #{collection.name}
      * Number of comments: #{comments.count}
      * Path: #{collection_card_path(collection, self, script_name: Account.script_name)}

      #{comments.last(MAX_COMMENTS).collect(&:to_prompt).join("\n")}
      END OF CARD #{id}
    PROMPT
  end
end
