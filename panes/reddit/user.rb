require 'rubygems'
require 'httparty'

class Reddit
  class User
    include HTTParty
    format :json
    base_uri "www.reddit.com/user"

    attr_reader :name

    def initialize(name)
      @name = name
    end

    def link_karma
      data['link_karma']
    end

    def comment_karma
      data['comment_karma']
    end

    protected

    def data
      @data ||= self.class.get("/#{@name}/about.json")['data']
    end
  end
end

