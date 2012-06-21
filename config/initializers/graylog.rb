
Log4rExceptionable::Configuration.configure do |config|

  # The default loggers used when a source logger is not available
  # required (at least one logger needs to be set, but you don't need
  # to set rack if using resque, and vice versa)
  #
  config.rack_failure_logger = "rails::failures::rack"
  config.resque_failure_logger = "rails::failures::resque"

  # Prevent the detection and use of the source class's logger
  # The source logger is taken from the resque class raising
  # the exception, rails controller raising the exception,
  # or rack_env['rack.logger']
  # optional - defaults to true
  #
  # config.use_source_logger = false

  # A whitelist of the context keys to include when logging.
  # If this is set, _only_these keys will show up.
  # optional - defaults to nil, so all keys get included
  #
  # config.context_inclusions = ['rack_env.rack.version']

  # A blacklist of the context keys to exclude when logging.
  # If this is set, the keys in here will not show up.
  # optional - defaults to nil, so no keys get excluded
  #
  config.context_exclusions = ['rack_env_action_controller.instance']

end

Rails.application.config.middleware.use Log4rExceptionable::RackFailureHandler

require 'resque/failure/redis'
require 'resque/failure/multiple'
Resque::Failure::Multiple.classes = [Log4rExceptionable::ResqueFailureHandler, Resque::Failure::Redis]
Resque::Failure.backend = Resque::Failure::Multiple

log_context_chained_after_fork_hook = Resque.after_fork
Resque.after_fork do |job|
    Log4r::MDC.put("pid", Process.pid)
    # our jobs all have a single hash as the argument
    Log4r::MDC.put("user_id", job.args.first['user_id']) if job.args.first && job.args.first['user_id']
    log_context_chained_after_fork_hook.call(job) if log_context_chained_after_fork_hook
end
