class Twitter < Pane
  title { "#{user.name} on Twitter" }
  stat("followers") { user.followers_count }

  protected

  def user
    @user ||= User.new(config.username)
  end
end

