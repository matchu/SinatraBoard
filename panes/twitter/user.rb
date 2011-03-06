class Twitter
  class User < Resource
    format :json
    base_uri "http://api.twitter.com/1"

    source "/users/show.json"
    query { {:screen_name => @name} }

    attr_resource :followers_count

    attr_reader :name

    def initialize(name)
      @name = name
    end
  end
end

