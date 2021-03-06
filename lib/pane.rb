require 'json'
require 'ostruct'

require 'core_ext/class'
require 'resource'

class Pane
  attr_reader :config

  def initialize(config={})
    @config = OpenStruct.new config
  end

  def link
    nil
  end

  # Runs each stat and returns them as a hash
  def stats
    values = {}
    self.class.stats.each do |name, behavior|
      values[name] = self.instance_eval(&behavior)
    end
    values
  end

  def to_json(*args)
    {
      :title => title,
      :link => link,
      :stats => stats_array
    }.to_json(*args)
  end

  class << self
    # List all pane classes that have been loaded so far
    def all_types
      @all_types ||= []
    end

    # Load all .rb files from the base path as panes
    def load(base_path)
      Dir.glob(File.join(base_path, "*.rb")).each do |pane_source|
        previous_pane_size = all_types.size
        require pane_source
        # When a subclass of Pane is defined, it runs this class's #inherited
        # method, which adds that class to the list of #all_types panes. If that
        # array didn't grow, then no subclass was defined, which likely
        # indicates that there's a Ruby file in the panes directory that was
        # placed there unintentionally.
        if all_types.size == previous_pane_size
          # The caller[1..-1] raises the exception two backtrace levels higher,
          # so that it comes from #load, which is clearer
          raise RuntimeError, "#{pane_source} did not define a subclass of Pane", caller[1..-1]
        end

        # Now, let's see if there's a directory containing helper classes for
        # this pane. If so, load all .rb files inside.
        components_path = pane_source.chomp '.rb'
        if File.directory? components_path
          Dir.glob(File.join(components_path, "**", "*.rb")).each do |component|
            require component
          end
        end
      end
    end

    # The list of stats and their behaviors
    def stats
      @stats ||= {}
    end

    # Returns the CamelCased class name as an underscored_string
    def underscore
      @underscore ||= name.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').downcase
    end

    protected

    def inherited(pane) # :nodoc:
      all_types << pane
    end

    def link(static_value=nil, &block)
      dynamic_field(:link, static_value, &block)
    end

    def title(static_value=nil, &block)
      dynamic_field(:title, static_value, &block)
    end

    # Define a stat of a pane. The block is passed the config hash, and its
    # return value is what gets displayed on the pane.
    def stat(name=nil, &block)
      raise ArgumentError, "Stat named #{name.inspect} already given" if stats[name]
      stats[name] = block
    end
  end

  protected

  def stats_array
    [].tap do |output|
      stats.each do |label, value|
        output << {:label => label, :value => value}
      end
    end
  end
end

