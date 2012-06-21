class ActionsController < ApplicationController

  def index
    logger.info "Showing actions index"
  end

  def create
    action = params[:action_name]
    logger.info "Executing action #{action}"
    notice = "Executed #{action}"
    case action
      when 'set_user'
        if params[:user_id].present?
          session[:user_id] = params[:user_id].to_i
        else
          session.delete(:user_id)
        end
      when 'log_message'
        params[:log_class].constantize.logger.error(params[:log_message])
      when 'controller_error'
        raise (params[:controller_error_message] || "Bad to the bone")
      when 'resque_ok'
        Resque.enqueue(DummyJob, :user_id => session[:user_id])
      when 'resque_error'
        Resque.enqueue(DummyJob, :user_id => session[:user_id],
                                 :error => (params[:resue_error_message] || "Resque should fail now"))
      else
        notice = "Bad action: #{action}"
    end
    redirect_to actions_path, :notice => notice 
  end
  
end
