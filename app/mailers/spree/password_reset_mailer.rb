module Spree
  class PasswordResetMailer < ApplicationMailer
    def reset_password(user, reset_url, store)
      @user      = user
      @reset_url = reset_url
      @store     = store

      mail(
        to:      user.email,
        from:    store.mail_from_address,
        subject: "#{store.name} - Reset your password"
      )
    end
  end
end