#!/usr/bin/env ruby
#
#  Created by Dean Hudson on 2007-09-10.
#  Copyright (c) 2007. All rights reserved.

$LOAD_PATH << File.dirname(__FILE__) + "/../lib/"

require "disk_monitor"

host  = `uname -n`.chomp.downcase
disks = `df -ik | grep '^/dev'`.split("\n")

disks.each do |disk|
  info = disk.split
  inode_mon  = InodeMonitor.new("127.0.0.1", "3333", "#{host}/df/inode#{info[0]}")
  kb_mon     = KbMonitor.new("127.0.0.1", "3333", "#{host}/df/kb#{info[0]}")
  
  inode_mon.tot_inodes = info[5].to_i + info[6].to_i
  inode_mon.used       = info[5]
  kb_mon.tot_blocks    = info[1]
  kb_mon.used          = info[2]
  
  [inode_mon, kb_mon].each {|mon| mon.report}
end