class Command::FilterByTag < Command
  store_accessor :data, :tag_id, :params

  validates_presence_of :tag_id

  def title
    "Filter by tag ##{tag&.title || tag_id} "
  end

  def execute
    redirect_to cards_path(**params.merge(tag_ids: [ tag_id ]))
  end

  private
    def tag
      Tag.find_by_id(tag_id)
    end
end
