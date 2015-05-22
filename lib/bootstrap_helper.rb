module BootstrapHelper
  def bootstrap_alert_classes_for(flash)
    classes = {
      success: "alert-success",
      error: "alert-danger",
      alert: "alert-warning",
      notice: "alert-info"
    }
    classes[flash.to_sym].nil? ? flash.to_s : "alert " + classes[flash.to_sym]
  end
  def bootstrap_navbar_link_to(*args)
    class_attr = ( request.fullpath == args[1] ? ' class="active"' : '' )
    "<li#{class_attr}>#{link_to(*args)}</li>".html_safe
  end
end
