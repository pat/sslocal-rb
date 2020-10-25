# frozen_string_literal: true

module Sslocal
end

if defined?(Puma)
  require "puma/plugin/sslocal"
  Puma::Plugins.register("sslocal", Puma::Plugin::SSLocal)
end

require "sslocal/railtie" if defined?(Rails)
