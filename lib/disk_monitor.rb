require 'status_monitor_client'

class InodeObserver < StatusMonitorClient
  attr :tot_inodes, true
  attr :used, true
  
  def ratio
    @ratio ||= used.to_f / tot_inodes.to_f
  end
  
  def report
    case
    when ratio < 0.75: info(self.class, ratio, "#{used} of #{tot_inodes} (#{ratio}%) inodes used.")
    when (ratio >= 0.75) && (ratio < 0.85): warn('InodeData', ratio, "#{used} of #{tot_inodes} (#{ratio}%) inodes used.")
    when (ratio >= 0.85) && (ratio < 0.99): error('InodeData', ratio, "#{used} of #{tot_inodes} (#{ratio}%) inodes used.")
    when ratio >= 0.99: fatal(self.class, ratio, "#{used} of #{tot_inodes} (#{ratio}%) inodes used.")
    end
  end
end

class KbObserver < StatusMonitorClient
  attr :tot_blocks, true
  attr :used, true
  
  def ratio
    @ratio ||= used.to_f / tot_blocks.to_f
  end
  
  def report
    case
    when ratio < 0.75: info(self.class, ratio, "#{used} of #{tot_blocks} (#{ratio}%) KB blocks used.")
    when (ratio >= 0.75) && (ratio < 0.85): warn('KbData', ratio, "#{used} of #{tot_blocks} (#{ratio}%) KB blocks used.")
    when (ratio >= 0.85) && (ratio < 0.99): error('KbData', ratio, "#{used} of #{tot_blocks} (#{ratio}%) KB blocks used.")
    when ratio >= 0.99: fatal(self.class, ratio, "#{used} of #{tot_blocks} (#{ratio}%) KB blocks used.")
    end
  end
end
