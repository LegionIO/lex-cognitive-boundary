# frozen_string_literal: true

require_relative 'lib/legion/extensions/cognitive_boundary/version'

Gem::Specification.new do |spec|
  spec.name          = 'lex-cognitive-boundary'
  spec.version       = Legion::Extensions::CognitiveBoundary::VERSION
  spec.authors       = ['Esity']
  spec.email         = ['matthewdiverson@gmail.com']

  spec.summary       = 'Cognitive boundary enforcement for LegionIO'
  spec.description   = 'Models permeable cognitive boundaries with integrity tracking and breach detection'
  spec.homepage      = 'https://github.com/LegionIO/lex-cognitive-boundary'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 3.4'

  spec.metadata['homepage_uri']        = spec.homepage
  spec.metadata['source_code_uri']     = spec.homepage
  spec.metadata['documentation_uri']   = "#{spec.homepage}/blob/main/README.md"
  spec.metadata['changelog_uri']       = "#{spec.homepage}/blob/main/CHANGELOG.md"
  spec.metadata['bug_tracker_uri']     = "#{spec.homepage}/issues"
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.match(%r{\A(?:test|spec|features)/})
    end
  end
  spec.require_paths = ['lib']
  spec.add_development_dependency 'legion-gaia'
end
