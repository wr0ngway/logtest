class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :setup_log_context

  protected
  
  def setup_log_context
    Log4r::MDC.get_context.keys.each {|k| Log4r::MDC.remove(k) }
    Log4r::MDC.put("pid", Process.pid)
    Log4r::MDC.put("user_id", session[:user_id]) if session[:user_id]
  end
  
end
