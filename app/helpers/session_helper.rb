module SessionHelper

  def user
    @user ||= User.find(session[:user_id])
  end

  def logged_in?
    session[:user_id].present?
  end

  def visitor
    @visitor ||= User.find(session[:visitor_id]) unless session[:visitor_id].blank?
  end

  def visiting?
    session[:visitor_id].present?
  end

  def flash_messages
    [:notice, :error].map do |type|
      if flash[type].present?
        haml "%li.#{type} #{flash[type]}"
      else
        ''
      end
    end.join
  end

end
