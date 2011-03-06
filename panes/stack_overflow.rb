class StackOverflow < Pane
  title { "#{user.name} on StackOverflow" }

  link { "http://stackoverflow.com/users/#{user.id}/#{user.name.downcase}" }

  stat("Reputation") { user.reputation }

  protected

  def user
    @user ||= User.new(config.user_id)
  end
end

