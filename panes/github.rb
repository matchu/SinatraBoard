class Github < Pane
  title { "#{user.name} on Github" }

  link { "https://github.com/#{user.name}" }

  stat("followers") { user.followers_count }

  protected

  def user
    @user ||= User.new(config.username)
  end
end

