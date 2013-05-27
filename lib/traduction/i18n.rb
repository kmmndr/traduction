require 'yaml'

module Traduction
  module I18n
    module I18nMethods
      def diff_locales(options = {})
        from_prefix, from_content = options[:from].to_a
        to_prefix, to_content = options[:to].to_a
        prefix = options[:prefix]

        from = YAML::load(from_content)[from_prefix]
        to = YAML::load(to_content)[to_prefix]

        messages = diff_yaml(from, to, prefix: prefix) do |k,v|
          yield k,v
        end

        display_messages(messages, empty_message: 'No added keys')
      end

      def display_messages(messages, options = {})
        empty_message = options[:empty_message] || 'Nothing found'
        if messages.present?
          messages.each { |m| puts m }
        else
          puts empty_message
        end
      end

      def load_default_locale
        i18n_default_locale = ::I18n.default_locale
        {
          :key => i18n_default_locale.to_s,
          :file => locale_file(i18n_default_locale)
        }
      end

      def locale_file(locale)
        File.join('config', 'locales', "#{locale}.yml")
      end

      def diff_yaml(from, to, options = {}, &block)
        messages = []
        prefix = options[:prefix] || nil
        from.diff_more(to, :ignore_values => true).flatten_keys(prefix).each do |k,v|
          messages << yield(k,v)
        end
        messages
      end
    end

    extend I18nMethods
  end
end
