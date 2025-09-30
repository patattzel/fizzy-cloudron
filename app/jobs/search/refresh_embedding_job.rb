class Search::RefreshEmbeddingJob < ApplicationJob
  discard_on ActiveJob::DeserializationError

  def perform(record)
    record.refresh_search_embedding
  end
end
