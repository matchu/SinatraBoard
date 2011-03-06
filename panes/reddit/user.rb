class Reddit
  class User < Resource
    format :json                       # It's a JSON resource
    base_uri "www.reddit.com/user"    # that lives in www.reddit.com/users,
    source { "/#{@name}/about.json" }  # specifically, at /[name]/about.json,
    scope 'data'                       # and the data we're interested in is
                                       # all under the 'data' key

    # Compare this file to twitter/user.rb and you'll notice that the #source
    # method can take both a plain string and a string in a block. When the
    # result depends on the pane's specific configuration, use a block. When
    # it would be the same for any pane of this type, use a string.

    # We'll be exposing the #comment_karma and #link_karma JSON keys
    attr_resource :comment_karma, :link_karma

    # Now, here's some custom behavior regarding how a user gets its name
    attr_reader :name

    def initialize(name)
      @name = name
    end
  end
end

