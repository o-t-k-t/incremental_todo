require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module IncrementalTodo
  class Application < Rails::Application
    config.load_defaults 5.2

    # 日本国内向け設定
    config.i18n.default_locale = :ja
    Faker::Config.locale = :ja

    config.time_zone = 'Tokyo'
    config.active_record.default_timezone = :local

    config.generators do |g|
      g.assets false
      g.helper false
      g.jbuilder false
      g.test_framework :rspec,
                       fixtures: true,
                       view_specs: false,
                       helper_specs: false,
                       routing_specs: false,
                       controller_specs: false,
                       request_specs: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
  end
end
