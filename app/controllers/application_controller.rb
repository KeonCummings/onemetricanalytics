class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def getAccessToken(platform)
  	social_account = AuthenticationProvider.where(name: platform).first
  	user_data = UserAuthentication.where("user_id = #{current_user.id} AND 
  							 authentication_provider_id = #{social_account.id}")
  	user_data.first.token
  end

  helper_method :getAccessToken
end
