# frozen_string_literal: true

module Spree
  module UserMailerDecorator
    def reset_password_instructions(user, token, opts = {})
      @user = user
      @current_store = current_store(opts)
      @edit_password_reset_url = opts[:reset_url] || edit_password_url(token, @current_store)

      mail to: user.email, from: from_address, reply_to: reply_to_address,
           subject: @current_store.name + ' ' + I18n.t(:subject, scope: [:devise, :mailer, :reset_password_instructions]),
           store_url: @current_store.url
    end
  end
end

Spree::UserMailer.prepend(Spree::UserMailerDecorator) if defined?(Spree::UserMailer)