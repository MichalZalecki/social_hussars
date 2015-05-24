class CallbacksController < Devise::OmniauthCallbacksController
    def github
      # Use the session locale set earlier; use the default if it isn't available.
      I18n.locale = session[:omniauth_login_locale] || I18n.default_locale
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', :kind => 'GitHub'
      @user = User.from_omniauth(request.env['omniauth.auth'])
      sign_in_and_redirect @user
    end
end
