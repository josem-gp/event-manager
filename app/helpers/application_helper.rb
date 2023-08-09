module ApplicationHelper
  def bootstrap_alert_class(key)
    case key
    when "success" then "alert alert-success alert-dismissible fade show"
    when "alert" then "alert alert-warning alert-dismissible fade show"
    when "error" then "alert alert-danger alert-dismissible fade show"
    else "alert alert-info alert-dismissible fade show"
    end
  end
end
