module UsersHelper
  def prepend_current_user_to(users_scope)
    users_scope.to_a.prepend(Current.user).uniq
  end
end
