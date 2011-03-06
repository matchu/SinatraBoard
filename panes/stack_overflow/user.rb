class StackOverflow
  class User < Resource
    format :json
    base_uri "www.stackoverflow.com/users/flair"
    source { "/#{id}.json" }

    attr_reader :id

    def initialize(id)
      @id = id
    end

    def name
      data['displayName']
    end

    def reputation
      data['reputation'].gsub(',', '').to_i
    end
  end
end

