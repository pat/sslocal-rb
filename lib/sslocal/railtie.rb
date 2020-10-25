# frozen_string_literal: true

require "sslocal/state"

module SSLocal
  class Railtie < Rails::Railtie
    initializer "sslocal.set_up_webpacker", :before => "webpacker.proxy" do
      state = SSLocal::State.new(Rails.env.to_s)
      Webpacker.config.dev_server[:https] = true if state.enabled?
    end

    config.after_initialize do |app|
      state = SSLocal::State.new(Rails.env.to_s)
      next unless state.enabled?

      policy = app.config.content_security_policy&.connect_src
      next if policy.blank?

      secure_policy = policy.collect do |item|
        item.gsub("http://", "https://").gsub("ws://", "wss://")
      end
      app.config.content_security_policy.connect_src(*secure_policy)
    end
  end
end
