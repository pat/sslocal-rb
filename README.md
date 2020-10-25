# SSLocal

SSLocal helps to make running SSL in your local Ruby development environment as streamlined as possible. Currently it's built to work with Rack apps that use Puma (including Rails).

Please **do not use this gem in production environments** - it's only meant for local development.

## Installation

1. Install [mkcert](https://github.com/FiloSottile/mkcert)
2. Add `config/certificates` to your application's `.gitignore` file.
3. Add this gem to your application's Gemfile - ideally just for the development environment.

```ruby
gem "sslocal", group: :development
```

4. Add the following lines to the end of your `config/puma.rb` file - adjusting the environment variable name if appropriate.

```ruby
if ENV.fetch("RAILS_ENV", "development") == "development"
  require "sslocal"
  plugin :sslocal
end
```

## Usage

1. Ensure the `config/certificates` folder exists (`mkdir -p config/certificates`).
2. Generate the local certificate via `mkcert`:

```sh
mkcert --cert-file config/certificates/development.crt \
  --key-file config/certificates/development.key \
  localhost 127.0.0.1
```

3. Boot your Rack/Rails app (whether via `rails server`, Foreman, Overmind, etc), and it should automatically use SSL using the generated certificate files.

If you're using SSLocal with a Rails app, it will change your app's settings dynamically to use HTTPS for Webpacker and ActionCable (if they're being used). However, if you are using Webpacker, you'll almost certainly want to install and set up [the SSLocal library for JavaScript](https://github.com/pat/sslocal-js) as well to keep matching protocols.

If you want to switch back to HTTP, just delete the certificate files and restart your Rack/Rails app. The certificate files are not precious, and can be deleted/regenerated as much as you like.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pat/sslocal-rb. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/pat/sslocal-rb/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is copyright Pat Allan, 2020, and is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in SSLocal's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pat/sslocal-rb/blob/master/CODE_OF_CONDUCT.md).
