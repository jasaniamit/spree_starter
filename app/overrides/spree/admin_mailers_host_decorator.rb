# Spree dynamically overwrites ActionMailer::Base.default_url_options[:host]
# with current_store.url before sending mail — correct for customer-facing
# emails (so links point at the storefront), but wrong for these admin-only
# mailers, which need to link back to the Rails backend itself.
#
# Each decorator below overrides default_url_options as an instance method,
# which takes priority over the inherited/shared class-level hash and can't
# be silently re-overwritten by Spree's store-url logic.

module Spree::ExportMailerDecorator
  def default_url_options
    { host: "server.nozfragrances.com", protocol: "https" }
  end
end

module Spree::InvitationMailerDecorator
  def default_url_options
    { host: "server.nozfragrances.com", protocol: "https" }
  end
end

module Spree::ReportMailerDecorator
  def default_url_options
    { host: "server.nozfragrances.com", protocol: "https" }
  end
end

# Wrapped in to_prepare so these only run once all of Spree's own classes
# are fully loaded — applying `prepend` at bare top-level can race Zeitwerk's
# autoload order and raise NameError during boot, which silently fails the
# deploy instead of erroring loudly.
Rails.application.config.to_prepare do
  Spree::ExportMailer.prepend Spree::ExportMailerDecorator unless Spree::ExportMailer.ancestors.include?(Spree::ExportMailerDecorator)
  Spree::InvitationMailer.prepend Spree::InvitationMailerDecorator unless Spree::InvitationMailer.ancestors.include?(Spree::InvitationMailerDecorator)
  Spree::ReportMailer.prepend Spree::ReportMailerDecorator unless Spree::ReportMailer.ancestors.include?(Spree::ReportMailerDecorator)
end
