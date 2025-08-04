class Ai::Tool::ListStatusChanges < Ai::Tool
  description <<-MD
    Lists all status changes accessible by the current user.
    The response is paginated so you may need to iterate through multiple pages to get the full list.
    Responses are JSON objects that look like this:
    ```
    {
      "collections": [
        {
          "id": 3,
          "card_id": 5,
          "body": "Jane Doe moved this to Done",
          "created_at": "2023-10-01T12:00:00Z",
          "creator": { "id": 2, "name": "Jane Doe" }
        }
      ],
      "pagination": {
        "next_page": "e3c2gh75e4..."
      }
    }
    ```
    Each collection object has the following fields:
    - id [Integer, not null]
    - name [String, not null]
  MD

  param :page,
    type: :string,
    desc: "Which page to return. Leave balnk to get the first page",
    required: false
  param :query,
    type: :string,
    desc: "If provided, will perform a semantinc search by embeddings and return only matching status changes",
    required: false
  param :card_id,
    type: :integer,
    desc: "If provided, will return only status changes for the specified card",
    required: false
  param :created_at_gte,
    type: :string,
    desc: "If provided, will return only comments created on or after after the given ISO timestamp",
    required: false
  param :created_at_lte,
    type: :string,
    desc: "If provided, will return only comments created on or before the given ISO timestamp",
    required: false

  def execute(**params)
    scope = Comment.all.includes(:card, :creator).where(creator: { role: "system" })

    scope = scope.search(params[:query]) if params[:query].present?
    scope = scope.where(card_id: params[:card_id].to_i) if params[:card_id].present?

    if params[:created_at_gte].present?
      timestamp = Time.iso8601(params[:created_at_gte])
      scope = scope.where(created_at: timestamp..)
    end

    if params[:created_at_lte].present?
      timestamp = Time.iso8601(params[:created_at_lte])
      scope = scope.where(created_at: ..timestamp)
    end

    page = GearedPagination::Recordset.new(
      scope,
      ordered_by: { created_at: :asc, id: :desc }
    ).page(params[:page])

    {
      collections: page.records.map do |comment|
        {
          id: comment.id,
          card_id: comment.card_id,
          body: comment.body.to_plain_text,
          created_at: comment.created_at.iso8601,
          creator: comment.creator.as_json(only: [ :id, :name ])
        }
      end,
      pagination: {
        next_page: page.next_param
      }
    }.to_json
  end
end
