# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "email_inquire/version"

Gem::Specification.new do |spec|
  spec.name = "email_inquire"
  spec.version = EmailInquire::VERSION
  spec.authors = ["Maxime Garcia"]
  spec.email = ["maxime.garcia@gmail.com"]

  spec.summary = "Library to validate email for format, common typos and one-time email providers"
  spec.description = spec.summary
  spec.homepage = "https://github.com/maximeg/email_inquire"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 2.3.0"

  spec.files =
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{^(test|spec|features)/})
    end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency("damerau-levenshtein", "~> 1.2")

  spec.add_development_dependency("bundler", "~> 2.0")
  spec.add_development_dependency("rake", "~> 10.0")
  spec.add_development_dependency("rspec", "~> 3.8.0")
  spec.add_development_dependency("rubocop", "0.62.0")
end
