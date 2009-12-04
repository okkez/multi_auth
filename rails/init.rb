# -*- coding: utf-8 -*-
# initialize
plugin_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

Dir.glob(File.join(plugin_root, 'lib', '*.rb')).each do |f|
  require(f)
end

config.plugin_paths << File.join(plugin_root, 'vendor/plugins')

config.gem "ruby-openid", :lib => 'openid'
config.gem "locale", :version => ">= 2.0.4"
config.gem "locale_rails", :version => ">= 2.0.4"
config.gem "gettext", :version => ">= 2.0.4"
config.gem "gettext_activerecord", :version => ">= 2.0.4"
config.gem "gettext_rails", :version => ">= 2.0.4"
config.gem "nayutaya-active-form", :lib => "active_form"

# FIXME: これで正しいのかもう少し考える
config.action_mailer.raise_delivery_errors = true
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = YAML.load_file(RAILS_ROOT + "/config/smtp.yml")
