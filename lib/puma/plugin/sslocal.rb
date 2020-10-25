# frozen_string_literal: true

require "puma"
require "puma/plugin"
require "sslocal/puma_rebinder"

module Puma
  class Plugin
    class SSLocal
      # Puma 4.x supplies an argument, but 5.x does not. We don't need it
      # either way.
      def initialize(_loader = nil); end

      # We don't actually want to modify the configuration here, as it only
      # impacts the file_config values. user_config values take precedence,
      # and the only way to cleanly impact those is via the launcher object
      # supplied in the `start` call.
      def config(_dsl); end

      # User-provided configuration (command-line arguments, environment
      # variables) take precedence over file-provided configuration (such as in
      # config/puma.rb). If there are certificate files present, we want each
      # configuration to use SSL if appropriate, so we rebind each one.
      def start(launcher)
        launcher.config.configure do |user_config, file_config, default_config|
          ::SSLocal::PumaRebinder.call(user_config)
          ::SSLocal::PumaRebinder.call(file_config)
          ::SSLocal::PumaRebinder.call(default_config)
        end
      end
    end
  end
end
