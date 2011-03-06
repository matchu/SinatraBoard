require 'rubygems'
require 'httparty'

class Twitter
  class User
    include HTTParty
    format :json
    base_uri "http://api.twitter.com/1"

    attr_reader :name

    def initialize(name)
      @name = name
    end

    def followers_count
      data['followers_count']
    end

    protected

    def data
      @data ||= self.class.get("/users/show.json", {:query => {:screen_name => @name}})
    end
  end
end

