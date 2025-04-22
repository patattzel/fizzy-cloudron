class Mention::CollectJob < ApplicationJob
  queue_as :default

  def perform(record, mentioner:)
    record.collect_mentions(mentioner:)
  end
end
