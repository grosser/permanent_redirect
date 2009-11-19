class ActionController::Base
  def redirect_to_with_permanent(options = {}, response_status = {})
    status = if options.is_a? Hash
      options.delete(:status) || response_status[:status]
    else
      response_status[:status]
    end
    status ||= 301

    redirect_to_without_permanent options, response_status.merge(:status => status)
  end

  alias_method_chain :redirect_to, :permanent
end