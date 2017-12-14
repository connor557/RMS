module Server
  class Connection < EventMachine::Connection
    def post_init
      @player = Model::Player.new
      @player.position = Model::Position.new 0.5, 4, 0.5

      @client = Client::Client.new(self, @player)
      Server.clients << @client
    end

    def receive_data(data)
      packet = Packet::parse(data)
      puts "Packet.inspect:" + packet.inspect

      @client.received(packet)
    end
  end

  class Server
    class << self
      attr_reader :host, :port

      attr_reader :clients
      
      # TODO: Add all variables to config.json
      def initialize
        @version = "v0.1-alpha"
        @log = RubycraftLogger.new("RubyCraft")
        @log.info("RubyMine #{@version}. Initializing...")
        if !File.exists?(File.join(File.dirname(__FILE__),"../world"))
          @log.info "Creating non-existant world directory."
          Dir.mkdir(File.join(File.dirname(__FILE__),"../world"))
        end
        @configuration = Configuration.new self
        if @configuration.max_players == -1
        	@configuration.max_players = 2147483647
        end
        @log.log.level = @configuration.log_level
        @connections = []
        @protocol = ProtocolHandler.new self
        @players = {}
        @terrain_generator = GeneratorHandeler.new(self)
        @worlds = [:worlds]
        @configuration.worlds.each do |world|
        @worlds << World.new(self,world)
      end
		
      
      def start(options)
        @host, @port, @name, @desc = options[:host], options[:port], name[:name], desc[:desc]
        @clients = []

        EventMachine::run do
          EventMachine::epoll
          EventMachine::start_server(@host, @port, Connection)
          
          con.log = @log
          #con.players = @players

          @log.log.info "Server name is currently set to #{@name}."
          @log.log.info "Server ready for players on #{@host}:#{@port}..."
          
          @console = EventMachine::open_keyboard(CommandHandler) do |con|
            con.server = self
        end
    end
    
    def stop
		@log.info "Stopping server..."
		@worlds.each do |world|
			world.save_all
		end
		EventMachine::stop_server(@server)
		exit 1
    end
    
    end
  end
end
