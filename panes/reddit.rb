class Reddit < Pane
  # Here, we set the behavior for title and stats using Pane's class methods
  # #title and #stat. The expression in the block will be reevaluated on each
  # page load, within the context of this Reddit object. (That's why they can
  # call #user.)

  title { "#{user.name} on Reddit" }

  link { "http://www.reddit.com/user/#{user.name}" }

  stat("link karma") { user.link_karma }
  stat("comment karma") { user.comment_karma }

  protected

  def user
    # Since we'd create a new pane object for each config, it's safe to cache
    # this user on this pane object.
    @user ||= User.new(config.username)
  end
end

