module Spree
  module PasswordResetMailerDecorator
    def reset_password(user, reset_url = nil)
      # Fix the broken URL by replacing the host concatenation
      if reset_url.present?
        fixed_url = reset_url.to_s.sub(
          /https?:\/\/([^\/]+?)([a-z])\//, # matches "domain.comin/" pattern
          'https://\1/\2/'
        )
      end
      super(user, fixed_url || reset_url)
    end
  end
end

Spree::PasswordResetMailer.prepend(Spree::PasswordResetMailerDecorator)
