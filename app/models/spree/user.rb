class Spree::User < Spree.base_class
  include Spree::UserAddress
  include Spree::UserMethods
  include Spree::UserPaymentSource

  # spree_auth_devise devise configuration
  devise :database_authenticatable if Spree::Auth::Config[:database_authenticatable]
  devise :recoverable if Spree::Auth::Config[:recoverable]
  devise :registerable if Spree::Auth::Config[:registerable]
  devise :confirmable if Spree::Auth::Config[:confirmable]
  devise :validatable if Spree::Auth::Config[:validatable]
  devise :rememberable, :trackable, :encryptable, encryptor: 'authlogic_sha512'

  def self.send_reset_password_instructions(attributes = {}, current_store = nil)
    recoverable = find_or_initialize_with_errors(reset_password_keys, attributes, :not_found)
    recoverable.send_reset_password_instructions(current_store) if recoverable.persisted?
    recoverable
  end

  def send_reset_password_instructions(current_store = nil)
    token = set_reset_password_token
    current_store_id = current_store&.id || Spree::Store.default.id
    send_devise_notification(:reset_password_instructions, token, { current_store_id: current_store_id })
    token
  end
end
