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
require 'sinatra'

# Local lib requirements
require 'pane'

## Set up our panes ##

# Load in panes at /panes
Pane.load(ROOT.join('panes'))

# Load in configs at /config
CONFIG_PATH = ROOT.join('config')
CONFIGS = begin
  configs = {}
  Pane.all_types.each do |pane_type|
    pane_config_path = CONFIG_PATH.join("#{pane_type.underscore}.yml")
    if File.exist? pane_config_path
      configs[pane_type.name] = YAML.load_file(pane_config_path)
    end
  end
  configs
end

## Respond to HTTP requests ##

require 'helpers'

get '/' do
  # Create a new instance of each pane, with the relevant config data
  @panes = Pane.all_types.map do |pane_type|
    pane_type.new CONFIGS[pane_type.name]
  end

  haml :statboard
end

