
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rms_api_ruby/version"

Gem::Specification.new do |spec|
  spec.name          = "rms_api_ruby"
  spec.version       = RmsApiRuby::VERSION
  spec.authors       = ["Kaicoh"]
  spec.email         = ["sumireminami@gmail.com"]

  spec.summary       = %q{A Ruby client for RMS(Rakuten Marchant Service) WEB API}
  spec.description   = %q{A Ruby client for RMS(Rakuten Marchant Service) WEB API}
  spec.homepage      = "https://github.com/Kaicoh"
  spec.license       = "MIT"

  spec.required_ruby_version = '~> 2.1'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'activesupport'
  spec.add_dependency 'hashie'
  spec.add_dependency 'savon', '~> 2.12.0'
  spec.add_dependency 'waterfall', '~> 1.2.0'

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rubocop', '~> 0.57.1'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'webmock'
end
