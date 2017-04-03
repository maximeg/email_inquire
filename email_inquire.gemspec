# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "email_inquire/version"

Gem::Specification.new do |spec|
  spec.name          = "email_inquire"
  spec.version       = EmailInquire::VERSION
  spec.authors       = ["Maxime Garcia"]
  spec.email         = ["maxime.garcia@gmail.com"]

  spec.summary       = "Library to validate email for format, common typos and one-time email providers"
  spec.description   = "Library to validate email for format, common typos and one-time email providers"
  spec.homepage      = "https://github.com/maximeg/email_inquire"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.0.0"

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "damerau-levenshtein", "~> 1.2"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.48"
end
