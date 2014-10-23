class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :detect_browser_os_and_device
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :authenticate_user!, only: [:ping]

  rescue_from CanCan::AccessDenied do |exception|
    render(file: File.join(Rails.root, 'public/403.html'), status: :forbidden, layout: false)
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
  
    def detect_browser_os_and_device
      case request.protocol
      when /http/i
        request.variant = [:http]
      when /https/i
        request.variant = [:https]
      end

      case request.user_agent
      when /iPad/i
        request.variant.push(:tablet)
      when /iPhone/i || /Windows Phone/i
        request.variant.push(:phone)
      when /Android/i && /mobile/i
        request.variant.push(:phone)
      when /Android/i
        request.variant.push(:tablet)
      end
      case request.user_agent
      when /Android/i
        request.variant.push(:android)
      when /iPhone/i || /iPad/i
        request.variant.push(:ios)
      when /Windows/i
        request.variant.push(:windows)
      when /Macintosh/i || /MacOS/i || /Darwin/i
        request.variant.push(:mac)
      when /BSD/i
        request.variant.push(:bsd)
      when /Linux/i || /Ubuntu/i
        request.variant.push(:linux)
      when /RIM/i || /Playbook/i || /BlackBerry/i || /BB10/i
        request.variant.push(:blackberry)
      when /CrOS/i
        request.variant.push(:chromeos)
      when /Firefox/i && /Mobile/i
        request.variant.push(:firefoxos)
      end
      case request.user_agent
      when /Chrome/i || /Chromium/i || /CrMo/i || /CriOS/i
        request.variant.push(:chrome)
      when /Firefox/i || /Fennec/i
        request.variant.push(:firefox)
      when /Safari/i && /Android/i
        request.variant.push(:androidb)
      when /Opera/i || /OPR/i || /Presto/i
        request.variant.push(:opera)
      when /MSIE/i || /Trident/i || /IE/i || /IEMobile/i
        request.variant.push(:ie)
      when /Safari/i || /iPhone/i || /iPad/i
        request.variant.push(:safari)
      when /RIM/i || /Playbook/i || /BlackBerry/i || /BB10/i
        request.variant.push(:blackberryb)
      end
    end
  end
