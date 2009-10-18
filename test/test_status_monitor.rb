require 'test/unit'
require 'stringio'
require 'rubygems'
require File.dirname(__FILE__) + '/../lib/status_monitor.rb'

class StatusMonitorTest < Test::Unit::TestCase
  def setup
    @server = StatusMonitor.new
  end
  
  def test_empty_string
    result = simulate_request("\n")
    assert_equal('1', result)
  end

  def test_invalid_level
    result = simulate_request("localhost/df/blocks,FooType,x,2.0,Is this thing on?")
    assert_equal('1', result)
  end
  
  def test_normal_case
    result = simulate_request("localhost/df/blocks,FooType,i,2.0,Is this thing on?")
    assert_equal('0', result)
  end

  def simulate_request(request)
    client = StringIO.new(request)
    @server.serve(client)
    client.string[request.size - 2 .. -2]
  end
end
