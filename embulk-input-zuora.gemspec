
Gem::Specification.new do |spec|
  spec.name          = "embulk-input-zuora"
  spec.version       = "0.1.0"
  spec.authors       = ["yusuken-freee"]
  spec.summary       = "Zuora input plugin for Embulk"
  spec.description   = "Loads records from Zuora."
  spec.email         = ["yusuken@c-fo.com"]
  spec.licenses      = ["MIT"]
  # TODO set this: spec.homepage      = "https://github.com/yusuken/embulk-input-zuora"

  spec.files         = `git ls-files`.split("\n") + Dir["classpath/*.jar"]
  spec.test_files    = spec.files.grep(%r{^(test|spec)/})
  spec.require_paths = ["lib"]

  #spec.add_dependency 'YOUR_GEM_DEPENDENCY', ['~> YOUR_GEM_DEPENDENCY_VERSION']
  spec.add_development_dependency 'embulk', ['>= 0.8.39']
  spec.add_development_dependency 'bundler', ['>= 1.10.6']
  spec.add_development_dependency 'rake', ['>= 10.0']
end
