class Reddit < Pane
  title { "#{user.name} on Reddit" }

  stat("link karma") { user.link_karma }
  stat("comment karma") { user.comment_karma }

  protected

  def user
    # Since we'd create a new pane object for each config, it's safe to cache
    # this user on this pane object.
    @user ||= User.new(config.username)
  end
end

