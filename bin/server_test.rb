$:.unshift File.expand_path('../../lib', __FILE__)

require 'optparse'
require 'server'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: server [options]"

  opts.on("-h", "--host HOST", "Host to listen on") do |h|
    options[:host] = h
  end
  
  opts.on("-p", "--port PORT", "Port to listen on") do |p|
    options[:port] = p.to_i
  end
  
  opts.on("-n", "--name NAME", "Name of your server (WIP)") do |s|
    options[:name] = n
  end
  
  opts.on("-d", "--desc DESCRIPTION", "Description of your server (WIP)") do |s|
    options[:desc] = d
  end
  
end.parse!

Server::start(options)
Server::stop
