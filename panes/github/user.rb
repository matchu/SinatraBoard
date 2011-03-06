class Github
  class User < Resource
    format :json
    base_uri "github.com/api/v2/json"

    source { "/user/show/#{name}" }
    scope "user"

    attr_resource :followers_count

    attr_reader :name

    def initialize(name)
      @name = name
    end
  end
end

