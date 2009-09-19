# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  #config.load_paths += %W[
  #    #{RAILS_ROOT}/app/models/posts
  #    #{RAILS_ROOT}/app/models/feeds
  #  ]

  config.action_controller.session = {
    :session_key => '_goaltron_session',
    :secret      => '181d7e704krktkreb790pogijwevojp5t09fpokvlkmad7033c18f9ddaf2ec845d44fc32bea'
  }

  #config.gem 'feed-normalizer'
  #config.gem 'hpricot'
end

require 'goaltron_init'