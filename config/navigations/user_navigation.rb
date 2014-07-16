# -*- coding: utf-8 -*-
# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|

  navigation.renderer = SimpleNavigation::Renderer::Bootstrap

  navigation.items do |secondary|
    secondary.item :user, user_signed_in?? current_user.login : 'Guest', '#' do |sub_nav|
      if user_signed_in?
        sub_nav.item :edit_profile, 'Edit profile', edit_user_registration_path
        sub_nav.item :logout, 'Logout', destroy_user_session_path, method: :delete
      else
        sub_nav.item :sign_up, 'Sign up', new_user_registration_path
        sub_nav.item :login, 'Login', new_user_session_path
      end
    end
    secondary.dom_class = "nav navbar-nav navbar-right"
    secondary.auto_highlight = false
  end
end
