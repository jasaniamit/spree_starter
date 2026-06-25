module Spree
  class PasswordResetSubscriber
    include Spree::Webhooks::Subscriber

    on 'customer.password_reset_requested' do |event|
      user  = Spree::User.find_by(id: event.data['user_id'])
      token = event.data['token']

      next unless user && token

      # Get host from env, strip any trailing slash to be safe
      host  = ENV.fetch('STORE_HOST', 'www.nozfragrances.com').sub(%r{/+\z}, '')
      path  = "/in/en/account/reset-password"

      reset_url = "https://#{host}#{path}?token=#{token}"

      Spree::PasswordResetMailer.reset_password(user, reset_url).deliver_later
    end
  end
end
