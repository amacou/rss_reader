class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :current_user

  private
  def current_user
    if session[:user_id] ||= cookies.signed[:user_id]
      @current_user ||= User.where(id: session[:user_id]).first
    end
  end

  def authenticate
    redirect_to :root unless current_user
  end
end
