class Command::Search < Command
  store_accessor :data, :query

  def execute
    redirect_to cards_path("terms[]": query)
  end

  def description
    "Search '#{query}"
  end

  def to_command
    query
  end
end
