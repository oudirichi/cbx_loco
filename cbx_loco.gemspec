# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cbx_loco/version"

Gem::Specification.new do |s|
  s.name = "cbx_loco"
  s.version = CbxLoco::VERSION
  s.authors = ["Cognibox"]
  s.email = ["developper@cognibox.com"]

  s.summary = %q{Write a short summary, because Rubygems requires one.}
  s.summary = %q{Provides rake tasks to synchronize translation assets between the codebase and Loco.}
  s.description = <<-TEXT
- `rake i18n:extract` extracts assets from server and client code, and uploads them to Loco using the developer API.
- `rake i18n:import` Imports assets from Loco using developer API into server-specific files and client-specific files

CbxLoco requires configuration of a Loco API key in `application.yml`
TEXT
  s.post_install_message = %q{Thanks for using CbxLoco! Remember to run rails generate cbx_loco:install}

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if s.respond_to?(:metadata)
    s.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  s.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # Allow parsing of PO files
  s.add_dependency "get_pomo", "~> 0.7.1"

  # Allow colors in console outputs
  s.add_dependency "colorize", "~> 0.8.1"

  s.add_dependency "rails", ">= 3.2"
  s.add_dependency "rest-client", "~> 1.6.7"

  s.add_development_dependency "byebug"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", ">= 3"
end
