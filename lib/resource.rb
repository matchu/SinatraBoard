require 'rubygems'
require 'httparty'

class Resource
  include HTTParty

  def data
    unless @data
      if query
        @data = self.class.get(source, :query => query)
      else
        @data = self.class.get(source)
      end
      self.class.scope.each do |scope_level|
        @data = @data[scope_level]
      end
      @data
    end
    @data
  end

  def query
    nil
  end

  class << self
    def attr_resource(*names)
      names.each do |name|
        name_str = name.to_s
        define_method name do
          data[name_str]
        end
      end
    end

    def query(static_value=nil, &block)
      dynamic_field(:query, static_value, &block)
    end

    def scope(*scope_levels)
      if scope_levels.empty?
        @scope ||= []
      else
        @scope = scope_levels
      end
    end

    def source(static_value=nil, &block)
      dynamic_field(:source, static_value, &block)
    end
  end
end

