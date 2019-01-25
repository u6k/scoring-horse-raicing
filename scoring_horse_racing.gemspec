
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "scoring_horse_racing/version"

Gem::Specification.new do |spec|
  spec.name          = "scoring_horse_racing"
  spec.version       = ScoringHorseRacing::VERSION
  spec.authors       = ["u6k"]
  spec.email         = ["u6k.apps@gmail.com"]

  spec.summary       = %q{Scoring horse races.}
  spec.description   = %q{Scoring horse races.}
  spec.homepage      = "https://github.com/u6k/scoring-horse-racing"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.17"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
