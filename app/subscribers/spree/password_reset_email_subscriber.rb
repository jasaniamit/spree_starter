# frozen_string_literal: true

module Spree
  class PasswordResetEmailSubscriber < Spree::Subscriber
    subscribes_to 'customer.password_reset_requested'

    on 'customer.password_reset_requested', :send_reset_password_email

    private

    def send_reset_password_email(event)
      email = event.payload['email']
      token = event.payload['reset_token']
      redirect_url = event.payload['redirect_url']

      user = Spree.user_class.find_by(email: email)
      return unless user

      store = Spree::Store.find_by(id: event.payload['store_id']) || Spree::Store.default
      return unless store.prefers_send_consumer_transactional_emails?

      # Build the reset URL with the token
      reset_url = if redirect_url.present?
        "#{redirect_url}?token=#{token}"
      else
        # Fallback to admin URL
        Rails.application.routes.url_helpers.admin_edit_password_url(
          reset_password_token: token,
          host: ENV.fetch('APP_HOST', 'server.nozfragrances.com'),
          protocol: 'https'
        )
      end

      Spree::UserMailer.reset_password_instructions(
        user,
        token,
        current_store_id: store.id,
        reset_url: reset_url
      ).deliver_later
    end
  end
end