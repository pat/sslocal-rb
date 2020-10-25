# frozen_string_literal: true

require "sslocal/state"

module SSLocal
  # Takes a Puma configuration/dsl object, and - if there are any non-SSL TCP
  # bindings and if the expected certificate files exist - then change those
  # bindings to use SSL with the certificate files.
  #
  # If there's an unexpected binding string, then return to the originally
  # supplied bindings.
  class PumaRebinder
    UnexpectedBindFormat = Class.new(StandardError)

    def self.call(dsl)
      new(dsl).call
    end

    def initialize(dsl)
      @dsl = dsl
      @binds = dsl.get(:binds)
    end

    def call
      return if binds.nil?
      return unless state.enabled?

      dsl.clear_binds!
      rebind
    rescue UnexpectedBindFormat => error
      puts "SSLocal: ssl not enabled due to #{error.message}"
      reset
    end

    private

    attr_reader :dsl, :binds

    def environment
      @environment ||= dsl.get(:environment)
    end

    def host_and_port(bind)
      matches = bind.scan(%r{\Atcp://(.*):(\d+)\z}).first
      if matches.nil? || matches.length != 2
        raise UnexpectedBindFormat, "unexpected bind format #{bind}"
      end

      matches.first.empty? ? ["0.0.0.0", matches.last] : matches
    end

    def rebind
      binds.each do |bind|
        if bind.start_with?("tcp://")
          dsl.ssl_bind(
            *host_and_port(bind),
            :key => state.key_path, :cert => state.cert_path
          )
        else
          dsl.bind(bind)
        end
      end
    end

    def reset
      dsl.clear_binds!
      binds.each { |bind| dsl.bind(bind) }
    end

    def state
      @state ||= ::SSLocal::State.new(environment)
    end
  end
end
