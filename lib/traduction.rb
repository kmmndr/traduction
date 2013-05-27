require "traduction/version"
require "traduction/hash_methods"
require "traduction/i18n"

module Traduction
  class Engine < Rails::Engine
  end if defined?(Rails) && Rails::VERSION::MAJOR >= 3
end
