module Spree
  class PasswordResetSubscriber < Spree::Subscriber
    subscribes_to 'customer.password_reset_requested'

    def handle(event)
      email = event.payload['email']
      token = event.payload['reset_token']
      store    = Spree::Store.find(event.store_id)

      user = Spree.user_class.find_by(email: email)
      return unless user

      # Build the frontend reset URL correctly
      reset_url = "https://#{store.url}/in/en/account/reset-password?token=#{CGI.escape(token)}"

      # Send a simple mailer with the correct link
      Spree::PasswordResetMailer.reset_password(user, reset_url, store).deliver_later
    end
  end
end
