module Bubble::Pinnable
  extend ActiveSupport::Concern

  included do
    has_many :pins, dependent: :destroy
  end

  def pinned_by?(user)
    pins.exists?(user: user)
  end

  def set_pinned(user, pinned)
    if pinned
      pins.find_or_create_by!(user: user)
    else
      pins.find_by(user: user)&.destroy
    end
  end
end
