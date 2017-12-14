libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift libdir unless $LOAD_PATH.include? libdir

require 'rubygems'
require 'eventmachine'
require 'json'
require 'zlib'
require 'logger'

require 'server/*'
require 'server/protocol/*'
require 'server/protocol/beta/*'
require 'server/generator/*'

# TODO: Add support for passing description/name at runtime. DONE!
# These are the main server options.
file = File.read "/json/config.json"
data = JSON.parse(file)

# Dynamically Loaded Classes
Dir.glob(File.dirname(__FILE__) + '/server/protocol/*.rb') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/server/protocol/*/*.rb') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/server/generator/*.rb') {|file| require file}

attr_accessor :interface, :port, :max_players, :description, :motd, :minversion, :maxversion, :protocols, :authenticate, :worlds, :default_world, :log_level

module Server
  DEFAULT_OPTIONS = {
    :host => data[srv_host],
    :port => data[srv_port],
    :name => data[srv_name],
    :desc => data[srv_desc],
    :terrain => data[config_terrain],
    :version => data[config_version],
    :worlds => data[srv_worlds],
    @max_players => data[max_players],
    @minversion => 0,
    @maxversion => 9001,
    @protocols => data[config_protocol],
    @authenticate => data[config_auth],
    @default_world => data[config_world],
    @worlds.push WorldConfig.new( "world1", 15, [FlatgrassGenerator] )
    @log_level => Logger::DEBUG
  }

  def self.start(options = {})
    options = DEFAULT_OPTIONS.merge(options)
    Server.start(options)
  end
end
