require 'yaml'

module Traduction
  module I18n
    module I18nMethods
      def diff_method(options = {}, &block)
        from_prefix, from_content = options[:from].to_a
        to_prefix, to_content = options[:to].to_a
        header = options[:header]
        format = options[:format] || :csv
        flatten = options[:flatten] || false

        from = YAML::load(from_content)[from_prefix]
        to = YAML::load(to_content)[to_prefix]

        data = yield from, to

        generate_csv(data, header: header, flatten: flatten)
      end

      def diff_all(options = {})
        diff_method(options.merge(flatten: true)) do |from, to|
          from.flatten_keys.merge_hash(to.flatten_keys)
        end
      end

      def diff_locales(options = {})
        prefix = options[:prefix]
        dont_ignore_values = options[:dont_ignore_values] || false

        diff_method(options) do |from, to|
          diff_yaml(from, to, prefix: prefix, dont_ignore_values: dont_ignore_values)
        end
      end

      def generate_csv(data, options = {})
        header = options[:header] || nil
        flatten = options[:flatten] || false

        CSV.generate(Traduction::CSV_FORMAT) do |csv|
          unless header.nil?
            case header
            when String
              csv << [header]
            when Array
              csv << header
            end
          end
#binding.pry
          data.each { |m| csv << (flatten ? m.flatten : m) } if data.present?
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
        prefix = options[:prefix] || nil
        ignore_values = !(options[:dont_ignore_values] || false)
        data = []

        from.diff_more(to, :ignore_values => ignore_values).flatten_keys(prefix).each do |k,v|
          data << [k,v]
        end

        data
      end
    end

    extend I18nMethods
  end
end
