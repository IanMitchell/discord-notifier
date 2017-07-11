require File.expand_path('../lib/discord_notifier/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "discord-notifier"
  spec.version       = Discord::Notifier::VERSION
  spec.authors       = ["Ian Mitchell"]
  spec.email         = ["ian.mitchel1@live.com"]

  spec.summary       = "A minimal wrapper for posting Discord Webhooks and Embeds"
  spec.homepage      = "https://github.com/ianmitchell/discord-notifier"
  spec.license       = "MIT"

  spec.files         = Dir["{lib}/**/*.rb"]
  spec.test_files    = Dir["{test}/**/*.rb"]
  spec.require_path  = "lib"

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
