class Command::GoToUser < Command
  store_accessor :data, :user_id

  validates_presence_of :user_id

  def execute
    redirect_to user
  end

  def title
    "Open user '#{user.name}'"
  end

  private
    def user
      User.find(user_id)
    end
end
