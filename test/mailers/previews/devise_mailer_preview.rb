class DeviseMailerPreview < ActionMailer::Preview
  def confirmation_instructions
    user = User.find_for_authentication(email: 'camden.narzt@metabolistics.com')

    new_token = Devise.token_generator.digest(User, :confirmation_token, user.confirmation_token)
    user.confirmation_token = new_token
    user.save

    Devise::Mailer.confirmation_instructions(user, new_token)
  end
end
