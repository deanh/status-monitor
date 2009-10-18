class Timer
  def initialize(resolution)
    @resolution = resolution
    @queue = []
    
    Thread.new do
      while true
        dispatch
        sleep(@resolution)
      end
    end
  end
  
  def self.get(interval)
    @timers ||= {}
    return @timers[interval] if @timers[interval]
    return @timers[interval] = self.new(interval)
  end
  
  def at(time, &block)
    time = time.to_f if time.kind_of?(Time)
    @queue.push [time,block]
  end
  
  private
  def dispatch
    now = Time.now.to_f
    ready, @queue = @queue.partition {|time, proc| time <= now}
    ready.each {|time, proc| proc.call(time)}
  end
end

class Monitor
  attr_reader :poll_interval
  @@timer = Timer.get(1)
  
  def poll(&block)
    now = Time.now
    result = do_polling
    if block
      block.call(result)
      @@timer.at(now + @poll_interval) { poll(&block) }
    else
      result
      @@timer.at(now + @poll_interval) { poll }
    end
  end
  
  protected
  def do_polling
    raise "No polling action."
  end
end