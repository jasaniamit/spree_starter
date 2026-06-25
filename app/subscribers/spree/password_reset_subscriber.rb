module Spree
  class PasswordResetSubscriber < Spree::Subscriber
    subscribes_to 'customer.password_reset_requested'
 
    def handle(event)
      email = event.payload['email']
      token = event.payload['reset_token']
 
      user = Spree.user_class.find_by(email: email)
      return unless user
 
      # Spree 5 removed Spree::UserMailer. Use Devise::Mailer directly.
      Devise::Mailer.reset_password_instructions(user, token).deliver_later
    end
  end
end
