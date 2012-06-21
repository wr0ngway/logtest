# Simple dummy job
class DummyJob
  include Lumber::LoggerSupport

  @queue = :dummy

  def self.perform(*args)
    logger.info "Started Dummy Job #{args.inspect}"
    
    if args.last.instance_of?(Hash)
      opts = args.pop
    else
      opts = {}
    end
    opts = HashWithIndifferentAccess.new(opts)
    
    sleep_min = opts[:min_sleep] || 0
    sleep_max = opts[:max_sleep] || 1
    sleep_delta = sleep_max - sleep_min
    sleep_time = sleep_min + rand(sleep_delta)

    raise opts[:error] if opts[:error]
    
    logger.info "Dummy Job sleeping for #{sleep_time} seconds"
    sleep(sleep_time)

    logger.info "Ended Dummy Job #{args.inspect}"
  end

end
