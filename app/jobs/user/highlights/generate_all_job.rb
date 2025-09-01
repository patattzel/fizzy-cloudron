class User::Highlights::GenerateAllJob < ApplicationJob
  queue_as :backend

  def perform(user)
    User.generate_all_weekly_highlights
  end
end
