#!/usr/bin/env ruby
#
#  Created by Dean Hudson on 2007-09-10.
#  Copyright (c) 2007. All rights reserved.

$LOAD_PATH << File.dirname(__FILE__) + "/../lib/"

require "connection_monitor"

host  = `uname -n`.chomp.downcase
mon   = ConnectionMonitor.new("127.0.0.1", "3333", "#{host}/connections")

mon.poll_connections
mon.report
