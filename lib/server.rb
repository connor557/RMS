libdir = File.dirname(__FILE__)
$LOAD_PATH.unshift libdir unless $LOAD_PATH.include? libdir

# TODO: Add support for MINGW EventMachine/ZLib
require 'eventmachine'
require 'zlib'

require 'server/io'
require 'server/map'
require 'server/packet'
require 'server/packets'
require 'server/client/packet_helpers'
require 'server/client/client'
require 'server/model'
require 'server/server'

# TODO: Add support for passing description/name at runtime.
# These are the main server options.
module Server
  DEFAULT_OPTIONS = {
    :host => 'localhost',
    :port => 25565,
    :stub => 'nil',
    :name => 'devserver',
    :desc => 'A Minecraft server',
  }

  def self.start(options = {})
    options = DEFAULT_OPTIONS.merge(options)
    Server.start(options)
  end
end
