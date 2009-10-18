require 'socket'

class StatusMonitorClient
  attr :slug, true

  INFO  = 'i'
  WARN  = 'w'
  ERROR = 'e'
  FATAL = 'f'

  def initialize(host, port, slg = nil)
    @slug = slg
    @sm = TCPSocket.new(host, port)
  end

  def info(type, meas, msg) log(type, INFO, meas, msg); end
  def warn(type, meas, msg) log(type, WARN, meas, msg); end
  def error(type, meas, msg) log(type, ERROR, meas, msg); end
  def fatal(type, meas, msg) log(type, FATAL, meas, msg); end

  private
  
  def log(type, level, meas, msg)
    puts [slug, type, level, meas, msg].join(',')
    @sm.puts [slug, type, level, meas, msg].join(',')
    @sm.readline
  end
end