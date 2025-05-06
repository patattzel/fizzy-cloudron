class Command::Search < Command
  store_accessor :data, :query

  def execute
    redirect_to cards_path("terms[]": query.presence)
  end

  def title
    "Search '#{query}'"
  end
end
