class Spree::User < Spree.base_class
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  include Spree::UserAddress
  include Spree::UserMethods
  include Spree::UserPaymentSource

  # Override to accept optional current_store argument (required by spree_auth_devise controllers)
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
