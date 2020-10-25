# frozen_string_literal: true

module SSLocal
  class State
    attr_reader :environment

    def initialize(environment)
      @environment = environment
    end

    def cert_path
      File.expand_path("config/certificates/#{environment}.crt")
    end

    def enabled?
      File.exist?(key_path) && File.exist?(cert_path)
    end

    def key_path
      File.expand_path("config/certificates/#{environment}.key")
    end
  end
end
