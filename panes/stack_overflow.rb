class StackOverflow < Pane
  title { "#{user.name} on StackOverflow" }

  stat("Reputation") { user.reputation }

  protected

  def user
    @user ||= User.new(config.user_id)
  end
end

