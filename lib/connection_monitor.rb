require 'status_monitor_client'

class ConnectionWatcher < StatusMonitorClient
  def tcp_connections
    @tcp_connections || 0
  end

  def poll_connections
    @tcp_connections = `netstat -tn | grep tcp | wc -l`.chomp.to_i
  end

  def report
    case
    when tcp_connections < 100: info('ConnectionData', tcp_connections, "#{tcp_connections} TCP connections.")
    when (tcp_connections >= 100) && (tcp_connections < 150): 
      warn('ConnectionData', tcp_connections, "#{tcp_connections} TCP connections.")
    when (tcp_connections >= 150) && (tcp_connections < 200): 
      error('ConnectionData', tcp_connections, "#{tcp_connections} TCP connections.")
    when tcp_connections >= 200: fatal(ConnectionData, tcp_connections, "#{tcp_connections} TCP connections.")
    end
  end
end
