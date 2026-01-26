require 'active_support/core_ext/integer/time'

Rails.application.configure do
  config.enable_reloading = false

  config.eager_load = true

  config.consider_all_requests_local = false

  config.active_storage.service = :local

  config.force_ssl = ENV['RAILS_FORCE_SSL'] == 'true'

  config.logger = ActiveSupport::Logger.new(STDOUT)
                                       .tap  { |logger| logger.formatter = ::Logger::Formatter.new }
                                       .then { |logger| ActiveSupport::TaggedLogging.new(logger) }

  config.log_tags = [:request_id]

  config.log_level = ENV.fetch('RAILS_LOG_LEVEL', 'info')

  config.action_mailer.perform_caching = false

  config.i18n.fallbacks = true

  config.active_support.report_deprecations = false

  config.active_record.dump_schema_after_migration = false

  config.action_controller.raise_on_missing_callback_actions = true

  routes.default_url_options = { host: ENV['APP_HOST'] }
  config.action_mailer.default_url_options = { host: ENV['APP_HOST'] }
  Rails.application.routes.default_url_options = { host: ENV['APP_HOST'] }
  config.active_storage.variant_processor = :mini_magick
  config.active_storage.checksum_implementation = OpenSSL::Digest::MD5
  config.active_storage.service = :cloudflare
end
