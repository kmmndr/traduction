# Traduction

Traduction is a little tool to help maintaining many locale files.

## Installation

Add this line to your application's Gemfile:

    gem 'traduction'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install traduction

## Usage

Usage is quite simple as the gem does not modify anything for you.
Using Rake tasks, you may list :

  - obsolete changes in a specific locale, compared to default locale
  - untranslated changes in a specific locale, still compared to default locale
  - added keys since an old git commit
  - all keys including modifications from a file (the file you might get back from translators)

Format used for import/output is CSV having ';' as field separator and '"' as text quote char.

Rake tasks are prefixed by 'traduction' namespace :

```
$ rake -T | grep 'traduction'
rake traduction:added[locale,revision]   # Show added keys for locale LOCALE since git revision
rake traduction:import[locale,filename]  # List keys from csv file returned by translators
rake traduction:obsolete[locale]         # Show obsolete keys for locale LOCALE
rake traduction:untranslated[locale]     # Show untranslated keys for locale LOCALE
```

If you do not specify locale, Traduction will use `I18n.default_locale`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Traduction is released under AGPLv3 license. Copyright (c) 2013 La Fourmi Immo
