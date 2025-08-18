class Command::Search < Command
  attr_reader :terms

  def initialize(terms)
    @terms = terms
  end


  def execute
    redirect_to search_path(q: terms)
  end
end
