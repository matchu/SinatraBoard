class Twitter
  class User < Resource
    format :json                         # It's a JSON resource
    base_uri "api.twitter.com/1"         # that lives in api.twitter.com/1,
    source "/users/show.json"            # specifically, at /users/show.json
    query { {:screen_name => @name} }    # when we provide ?screen_name=[name]

    # We'll be exposing the #followers_count JSON key
    attr_resource :followers_count

    # Now, here's some custom behavior about how a user gets its name
    attr_reader :name

    def initialize(name)
      @name = name
    end
  end
end

