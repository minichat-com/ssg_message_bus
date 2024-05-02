# frozen_string_literal: true

require_relative "lib/ssg_message_bus/version"

Gem::Specification.new do |spec|
  spec.name = "ssg_message_bus"
  spec.version = SSGMessageBus::VERSION
  spec.authors = ["Andriy Tyurnikov"]
  spec.email = ["Andriy.Tyurnikov@gmail.com"]

  spec.summary = "SSG Message Bus"
  spec.description = "Messaging between SSG sub-systems"
  spec.homepage = "https://github.com/minichat-com/ssg_message_bus"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "json", "~> 2.7.2"
  spec.add_dependency "ruby-kafka", "~> 1.5"
  spec.add_dependency "google-cloud-pubsub", "~> 2.18"

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata["rubygems_mfa_required"] = "true"
end
