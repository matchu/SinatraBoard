## Set up the environment ##

require 'pathname'
ROOT = Pathname.new(File.expand_path('..', __FILE__))
$:.unshift ROOT.to_s
$:.unshift ROOT.join('lib').to_s

# Stdlib requirements
require 'yaml'

# Rubygem requirements
require 'rubygems'
require 'haml'
require 'sinatra/base'

# Local lib requirements
require 'pane'

## Set up our panes ##

# Load in panes at /panes
Pane.load(ROOT.join('panes'))

# Load in configs at /config/panes
PANE_CONFIG_PATH = ROOT.join('config', 'panes')
PANE_CONFIGS = begin
  configs = {}
  Pane.all_types.each do |pane_type|
    pane_config_path = PANE_CONFIG_PATH.join("#{pane_type.underscore}.yml")
    if File.exist? pane_config_path
      configs[pane_type.name] = YAML.load_file(pane_config_path)
    end
  end
  configs
end

# Now that they're loaded, let's get them ordered like we want 'em
PANE_ORDER = YAML.load_file(ROOT.join('config', 'pane_order.yml'))
ORDERED_PANE_TYPES = begin
  pane_types_by_name = {}
  Pane.all_types.each do |pane_type|
    pane_types_by_name[pane_type.underscore] = pane_type
  end
  PANE_ORDER.map do |pane_name|
    pane_types_by_name[pane_name]
  end
end

## Respond to HTTP requests ##
class Sinatraboard < Sinatra::Base
  require 'helpers'

  set :public, ROOT.join('public')

  get '/' do
    # Create a new instance of each pane, with the relevant config data
    @panes = ORDERED_PANE_TYPES.map do |pane_type|
      pane_type.new PANE_CONFIGS[pane_type.name]
    end

    haml :statboard
  end
end

