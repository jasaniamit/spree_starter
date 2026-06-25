module Spree
  class PasswordResetSubscriber < Spree::Subscriber
    subscribes_to 'customer.password_reset_requested'

    def handle(event)
      email = event.payload['email']
      token = event.payload['reset_token']
      store_id = event.store_id

      user = Spree.user_class.find_by(email: email)
      return unless user

      Spree::UserMailer.reset_password_instructions(
        user, token, { current_store_id: store_id }
      ).deliver_later
    end
  end
end