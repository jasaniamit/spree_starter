# Configure Spree Preferences
Spree.config do |config|
  config.send_core_emails = false
end

Spree.dependencies do |dependencies|
end

Rails.application.config.after_initialize do
  # Send password reset email when Spree fires customer.password_reset_requested
  ActiveSupport::Notifications.subscribe('spree.customer.password_reset_requested') do |*args|
    event       = ActiveSupport::Notifications::Event.new(*args)
    payload     = event.payload
    email       = payload[:email] || payload['email']
    reset_token = payload[:reset_token] || payload['reset_token']

    next unless email.present? && reset_token.present?

    user = Spree::User.find_by(email: email)
    next unless user

    Devise::Mailer.reset_password_instructions(user, reset_token, {}).deliver_later
  end
end

Spree.user_class = 'Spree::User'
Spree.admin_user_class = 'Spree::AdminUser'

Spree.google_places_api_key = ENV['GOOGLE_PLACES_API_KEY'] if ENV['GOOGLE_PLACES_API_KEY'].present?
Spree.screenshot_api_token = ENV['SCREENSHOT_API_TOKEN'] if ENV['SCREENSHOT_API_TOKEN'].present?

Rails.application.config.to_prepare do
  require_dependency 'spree/authentication_helpers'
end
