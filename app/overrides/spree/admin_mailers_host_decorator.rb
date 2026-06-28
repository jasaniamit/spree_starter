module Spree
  module AdminMailersHostDecorator

    module ExportMailerDecorator
      def default_url_options
        {
          host: "server.nozfragrances.com",
          protocol: "https"
        }
      end
    end

    module InvitationMailerDecorator
      def default_url_options
        {
          host: "server.nozfragrances.com",
          protocol: "https"
        }
      end
    end

    module ReportMailerDecorator
      def default_url_options
        {
          host: "server.nozfragrances.com",
          protocol: "https"
        }
      end
    end

  end
end

Rails.application.config.to_prepare do
  Spree::ExportMailer.prepend(
    Spree::AdminMailersHostDecorator::ExportMailerDecorator
  ) unless Spree::ExportMailer <
           Spree::AdminMailersHostDecorator::ExportMailerDecorator

  Spree::InvitationMailer.prepend(
    Spree::AdminMailersHostDecorator::InvitationMailerDecorator
  ) unless Spree::InvitationMailer <
           Spree::AdminMailersHostDecorator::InvitationMailerDecorator

  Spree::ReportMailer.prepend(
    Spree::AdminMailersHostDecorator::ReportMailerDecorator
  ) unless Spree::ReportMailer <
           Spree::AdminMailersHostDecorator::ReportMailerDecorator
end
