class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :detect_device_format
  before_filter :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
     render(:file => File.join(Rails.root, 'public/403.html'), :status => :forbidden, :layout => false)
  end

  def ping
    filtered = request.env.select do |k,v| ['HTTP_USER_AGENT','REMOTE_ADDR'].include? k end
    render json: filtered
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end

  private

  def detect_device_format
     case request.user_agent
        when /iPad/i
          request.variant = :tablet
        when /iPhone/i
          request.variant = :phone
        when /Android/i && /mobile/i
          request.variant = :phone
        when /Android/i
          request.variant = :tablet
        when /Windows Phone/i
          request.variant = :phone
        end
     end
  end
