module Bubble::Watchable
  extend ActiveSupport::Concern

  included do
    has_many :watches, dependent: :destroy

    after_create :create_initial_watches
  end

  def watched_by?(user)
    watchers_and_subscribers.include?(user)
  end

  def set_watching(user, watching)
    watches.where(user: user).first_or_create.update!(watching: watching)
  end

  def watchers_and_subscribers
    User.where(id: bucket.subscribers.pluck(:id) +
               watches.watching.pluck(:user_id) - watches.not_watching.pluck(:user_id))
  end

  private
    def create_initial_watches
      Watch.insert_all(bucket.users.pluck(:id).collect { |user_id| { user_id: user_id, bubble_id: id } })
    end
end
