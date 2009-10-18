require 'ping'

class PingMonitor < Monitor
  attr_reader :host, :port

  def initialize(host, port)
    @poll_interval = 5
    @host   = host
    @port   = port
  end

  def do_polling
    puts "Pinging #{@host}..."
    Ping.pingecho(@host, 4, port)
  end
end
