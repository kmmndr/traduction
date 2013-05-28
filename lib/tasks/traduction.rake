require 'git'

class Hash
  include Traduction::HashMethods
end

namespace :traduction do

  desc "Show untranslated keys for locale LOCALE"
  task :untranslated, [:locale] do |t, args|
    args.with_defaults(:locale => 'es')
    locale_to_check = args.locale
    default_locale = Traduction::I18n.load_default_locale

    Traduction::I18n.diff_locales(from: [default_locale[:key], File.open(default_locale[:file])],
                 to: [locale_to_check, File.open(Traduction::I18n.locale_file(locale_to_check))],
                 prefix: locale_to_check,
                 empty_message: 'No untranslated key') do |k,v|
      "'#{k}' key missing (original value '#{v}')"
    end
  end
  task :untranslated => :environment

  desc "Show obsolete keys for locale LOCALE"
  task :obsolete, [:locale] do |t, args|
    args.with_defaults(:locale => 'es')
    locale_to_check = args.locale
    default_locale = Traduction::I18n.load_default_locale

    Traduction::I18n.diff_locales(from: [locale_to_check, File.open(Traduction::I18n.locale_file(locale_to_check))],
                 to: [default_locale[:key], File.open(default_locale[:file])],
                 prefix: locale_to_check,
                 empty_message: 'No obsolete key') do |k,v|
      "'#{k}' (value \"#{v}\") key is obsolete"
    end
  end
  task :obsolete => :environment

  desc "Show added keys for locale LOCALE since git revision"
  task :added, [:locale, :revision] do |t, args|
    default_locale = Traduction::I18n.load_default_locale
    args.with_defaults(:locale => default_locale[:key], :revision => 'HEAD~1')
    locale_to_check = args.locale

    g = Git.open(Rails.root) #, :log => Logger.new(STDOUT))

    commit_sha = args.revision

    Traduction::I18n.diff_locales(from: [locale_to_check, File.open(Traduction::I18n.locale_file(locale_to_check))],
                 to: [locale_to_check, g.object("#{commit_sha}:#{Traduction::I18n.locale_file(locale_to_check)}").contents],
                 prefix: default_locale[:key],
                 empty_message: 'No added key') do |k,v|
      "'#{k}' key has been added since #{commit_sha} (value '#{v}')"
    end
  end
  task :added => :environment

end
