class Mention::CreateJob < ApplicationJob
  queue_as :default

  def perform(record, mentioner:)
    record.create_mentions(mentioner:)
  end
end
