class User::Filtering
  attr_reader :user, :filter

  delegate :as_params, to: :filter

  def initialize(user, filter)
    @user, @filter = user, filter
  end

  def collections
    @collections ||= user.collections.ordered_by_recently_accessed
  end

  def tags
    Tag.all.alphabetically
  end

  def users
    User.active.alphabetically
  end

  def filters
    @filters ||= Current.user.filters.all
  end

  def collections_title
    if filter.collections.none?
      collections.one? ? collections.first.name : "All collections"
    elsif filter.collections.one?
      filter.collections.first.name
    else
      filter.collections.map(&:name).to_sentence
    end
  end
end
