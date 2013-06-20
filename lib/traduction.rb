require "traduction/version"
require "traduction/hash_methods"
require "traduction/i18n"

module Traduction
  CSV_FORMAT = { :col_sep => ';', :force_quotes=>true, :quote_char => '"' }
  class Engine < Rails::Engine
  end if defined?(Rails) && Rails::VERSION::MAJOR >= 3
end
