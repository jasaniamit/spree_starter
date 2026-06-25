require "active_support/core_ext/integer/time"

Rails.application.configure do
  # Code is not reloaded between requests.
  config.enable_reloading = false

  # Eager load code on boot for better performance.
  config.eager_load = true

  # Full error reports are disabled.
  config.consider_all_requests_local = false

  # Enable caching.
  config.action_controller.perform_caching = true

  # Cache assets for far-future expiry.
  config.public_file_server.headers = { "cache-control" => "public, max-age=#{1.year.to_i}" }

  # Store uploaded files locally.
  config.active_storage.service = :local

  # SSL assumptions.
  config.assume_ssl = true
  config.force_ssl = true

  # Logging.
  config.log_tags = [ :request_id ]
  config.logger   = ActiveSupport::TaggedLogging.logger(STDOUT)
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info")
  config.silence_healthcheck_path = "/up"
  config.active_support.report_deprecations = false

  # Cache store.
  if ENV['REDIS_CACHE_URL'].present?
    cache_servers = ENV['REDIS_CACHE_URL'].split(',')
    config.cache_store = :redis_cache_store, {
      url: cache_servers,
      connect_timeout:    30,
      read_timeout:       0.2,
      write_timeout:      0.2,
      reconnect_attempts: 2,
    }
  else
    config.cache_store = :memory_store
  end

  # Background jobs.
  config.active_job.queue_adapter = :sidekiq

  # Action Mailer.
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_caching = false

  # Default URL for mailers.
  config.action_mailer.default_url_options = {
    host: "www.nozfragrances.com",
    protocol: "https"
  }
  config.action_mailer.asset_host = "https://www.nozfragrances.com"

  # Mailtrap SMTP configuration
  config.action_mailer.smtp_settings = {
    address:              "live.smtp.mailtrap.io",
    port:                 587,
    domain:               "nozfragrances.com",
    user_name:            "api",
    password:             ENV["MAILTRAP_API_TOKEN"],
    authentication:       :plain,
    enable_starttls_auto: true
  }

  # I18n.
  config.i18n.fallbacks = true

  # Schema.
  config.active_record.dump_schema_after_migration = false
  config.active_record.attributes_for_inspect = [ :id ]

  # Host authorization.
  config.hosts = [
    "nozfragrances.com",
    "www.nozfragrances.com",
    "server.nozfragrances.com",
    "api.nozfragrances.com",
    /.*\.nozfragrances\.com/
  ]
  config.host_authorization = { exclude: ->(request) { request.path == "/up" } }

  # Global default URL options (critical for Spree Admin).
  Rails.application.routes.default_url_options = {
    host: "www.nozfragrances.com",
    protocol: "https"
  }
end
