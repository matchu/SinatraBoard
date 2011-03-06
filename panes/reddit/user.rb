class Reddit
  class User < Resource
    format :json
    base_uri "www.reddit.com/user"

    source { "/#{@name}/about.json" }
    scope 'data'

    attr_resource :comment_karma, :link_karma

    attr_reader :name

    def initialize(name)
      @name = name
    end
  end
end

