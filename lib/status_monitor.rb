require 'rubygems'
require 'active_record'
require 'gserver'

ActiveRecord::Base.establish_connection(
  :adapter => 'mysql',
  :host => '127.0.0.1',
  :database => 'status_monitor'
)

class DataPoint < ActiveRecord::Base; end

class StatusMonitor < GServer
  VERSION = '0.1.0'
  
  def initialize(host = "127.0.0.1", port = '3333')
    super(port, host)
    @level_map = {
      'i' => 'info',
      'w' => 'warn',
      'e' => 'error',
      'f' => 'fatal'
    }
  end
  
  # expects CSV data in the following format:
  # host, type, level, measurement, message
  def serve(client)
    slug, type, level, meas, msg = client.readline.chomp.split(',', 5)
    if @level_map.has_key?(level)
      data = DataPoint.new
      data.slug = slug
      data[:type] = type # ActiveRecord STI hackery
      data.level = @level_map[level]
      data.measurement = meas
      data.message = msg
      data.timestamp = Time.now
      data.save
      client.puts('0')
    else
      client.puts('1')
    end
  end
end
