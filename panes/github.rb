class Github < Pane
  title { "#{user.name} on Github" }

  stat("followers") { user.followers_count }

  protected

  def user
    @user ||= User.new(config.username)
  end
end

