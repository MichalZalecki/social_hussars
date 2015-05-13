module ApplicationHelper
  def bootstrap_alert_classes_for(flash_type)
    classes_mapping = {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-info"
    }
    "alert " + classes_mapping[flash_type.to_sym] || flash_type.to_s
  end
  def bootstrap_navbar_link_to(*args)
    class_attr = ( request.fullpath == args[1] ? ' class="active"' : '' )
    "<li#{class_attr}>#{link_to(*args)}</li>".html_safe
  end
end
