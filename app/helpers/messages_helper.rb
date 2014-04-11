module MessagesHelper
  def bootstrap_class_for(flash_type)
    case flash_type
    when :success then 'alert-success'
    when :error then 'alert-error'
    when :alert then 'alert-block'
    when :notice then 'alert-info'
    when :danger then 'alert-danger'
    else
      flash_type.to_s
    end
  end
end
