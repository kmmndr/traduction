require 'git'
require 'csv'
require 'active_support'

class Hash
  include Traduction::HashMethods
end

namespace :traduction do

  desc "Show untranslated keys for locale LOCALE"
  task :untranslated, [:locale] do |t, args|
    args.with_defaults(:locale => 'es')
    locale_to_check = args.locale
    default_locale = Traduction::I18n.load_default_locale

    puts Traduction::I18n.diff_locales(
                 from: [default_locale[:key], File.open(default_locale[:file])],
                 to: [locale_to_check, File.open(Traduction::I18n.locale_file(locale_to_check))],
                 prefix: locale_to_check,
                 header: ['Untranslated keys', 'original value'])
  end
  task :untranslated => :environment

  desc "Show obsolete keys for locale LOCALE"
  task :obsolete, [:locale] do |t, args|
    args.with_defaults(:locale => 'es')
    locale_to_check = args.locale
    default_locale = Traduction::I18n.load_default_locale

    puts Traduction::I18n.diff_locales(
                 from: [locale_to_check, File.open(Traduction::I18n.locale_file(locale_to_check))],
                 to: [default_locale[:key], File.open(default_locale[:file])],
                 prefix: locale_to_check,
                 header: ['Obsolete key', 'value'])
  end
  task :obsolete => :environment

  desc "Show added keys for locale LOCALE since git revision"
  task :added, [:locale, :revision] do |t, args|
    default_locale = Traduction::I18n.load_default_locale
    args.with_defaults(:locale => default_locale[:key], :revision => 'HEAD~1')
    locale_to_check = args.locale

    g = Git.open(Rails.root) #, :log => Logger.new(STDOUT))

    commit_sha = args.revision

    puts Traduction::I18n.diff_locales(
                 from: [locale_to_check, File.open(Traduction::I18n.locale_file(locale_to_check))],
                 to: [locale_to_check, g.object("#{commit_sha}:#{Traduction::I18n.locale_file(locale_to_check)}").contents],
                 prefix: default_locale[:key],
                 header: ["Added key since #{commit_sha}", 'value'])
  end
  task :added => :environment

  desc "List keys from csv file returned by translators"
  task :import, [:locale, :filename] do |t, args|
    default_locale = Traduction::I18n.load_default_locale
    args.with_defaults(:locale => default_locale[:key], :filename => nil)
    locale_to_check = args.locale

    keys_to_import = {}

    csv = CSV.foreach(args.filename, Traduction::CSV_FORMAT) do |row|
      yaml_full = row[0].split('.')
      keys = {}
      yaml_full.reverse.each_with_index do |key, idx|
        if idx == 0
          keys[key] = row[1]
        else
          keys = {key => keys}
        end
      end
      keys_to_import.deep_merge!(keys)
    end

    origin_content = YAML::load(File.open(Traduction::I18n.locale_file(locale_to_check)))
    puts origin_content.to_hash.deep_merge(keys_to_import).sort_by_key(true).to_yaml
  end
  task :import => :environment

end
