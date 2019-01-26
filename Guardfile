# frozen_string_literal: true

ignore(%r{^(pkg|tmp)/})

group :spec_then_quality, halt_on_fail: true do
  guard(:rspec, cmd: "bundle exec rspec") do
    require "guard/rspec/dsl"
    dsl = Guard::RSpec::Dsl.new(self)

    # RSpec files
    rspec = dsl.rspec
    watch(rspec.spec_helper) { rspec.spec_dir }
    watch(rspec.spec_support) { rspec.spec_dir }
    watch(rspec.spec_files)

    # Ruby files
    ruby = dsl.ruby
    dsl.watch_spec_files_for(ruby.lib_files)
  end

  guard(:rubocop, all_on_start: false) do
    watch(%r{^(?:lib|spec)/})
    watch("Gemfile")
    watch("Rakefile")
    watch(/\.gemspec$/)
    watch(".rubocop.yml") { "." }
    watch("spec/.rubocop.yml") { "spec" }
  end
end
