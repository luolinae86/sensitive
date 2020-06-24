require_relative 'lib/sensitive/version'

Gem::Specification.new do |spec|
  spec.name          = "sensitive"
  spec.version       = Sensitive::VERSION
  spec.authors       = ["luolin"]
  spec.email         = ["luolinae86@gmail.com"]

  spec.summary       = %q{Ruby敏感词过滤}
  spec.description   = %q{用Ruby实现DFA算法，实现敏感词过滤, 自带敏感词库}
  spec.homepage      = "https://github.com/luolinae86/sensitive"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = "https://github.com/luolinae86/sensitive" 
  spec.metadata["source_code_uri"] = "https://github.com/luolinae86/sensitive"
  spec.metadata["changelog_uri"] = "https://github.com/luolinae86/sensitive"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
