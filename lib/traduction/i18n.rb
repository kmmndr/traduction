require 'yaml'

module Traduction
  module I18n
    module I18nMethods
      def diff_locales(options = {})
        from_prefix, from_content = options[:from].to_a
        to_prefix, to_content = options[:to].to_a
        prefix = options[:prefix]
        header = options[:header]
        format = options[:format] || :csv

        from = YAML::load(from_content)[from_prefix]
        to = YAML::load(to_content)[to_prefix]

        data = diff_yaml(from, to, prefix: prefix)

        generate_csv(data, header: header)
      end

      def generate_csv(data, options = {})
        header = options[:header] || nil

        CSV.generate(Traduction::CSV_FORMAT) do |csv|
          unless header.nil?
            case header
            when String
              csv << [header]
            when Array
              csv << header
            end
          end
          data.each { |m| csv << m } if data.present?
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
        data = []

        from.diff_more(to, :ignore_values => true).flatten_keys(prefix).each do |k,v|
          data << [k,v]
        end

        data
      end
    end

    extend I18nMethods
  end
end
#
# 
#text: (CSV.generate do |csv|
# 63           csv << @header
# 64           @ragreements.each do |o|
# 65             csv << o.values.map { |l| l.is_a?(Array) ? l.join("\n") : l }
# 66           end
# 67         end)
#
#
