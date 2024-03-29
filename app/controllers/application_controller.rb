class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  layout 'container'

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def self.default_url_options(options = {})
    options.merge({ :locale => I18n.locale })
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :username
    devise_parameter_sanitizer.for(:sign_up) << :avatar
    devise_parameter_sanitizer.for(:account_update) << :avatar
  end
end
