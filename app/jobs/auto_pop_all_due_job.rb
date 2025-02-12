class AutoPopAllDueJob < ApplicationJob
  queue_as :default

  def perform
    Bubble.auto_pop_all_due
  end
end
