# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name     = "sslocal"
  spec.version  = "0.1.0"
  spec.authors  = ["Pat Allan"]
  spec.email    = ["pat@freelancing-gods.com"]

  spec.summary  = "Make local environment SSL as streamlined as possible."
  spec.homepage = "https://github.com/pat/sslocal-rb"
  spec.license  = "MIT"

  spec.metadata["homepage_uri"]          = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"
  spec.metadata["source_code_uri"]       = spec.homepage

  spec.require_paths = ["lib"]
  spec.files = Dir["lib/**/*"] + %w[README.md LICENSE.txt CODE_OF_CONDUCT.md]

  # spec.bindir        = "exe"
  # spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }

  spec.add_development_dependency "puma"
  spec.add_development_dependency "rspec", "~> 3.9"
  spec.add_development_dependency "rubocop", "~> 1.0"
  spec.add_development_dependency "rubocop-packaging", "~> 0.5"
  spec.add_development_dependency "rubocop-performance", "~> 1.8"
end
