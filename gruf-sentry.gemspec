# frozen_string_literal: true

# Copyright (c) 2020-present, BigCommerce Pty. Ltd. All rights reserved
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
# documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
# rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
# persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
# OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gruf/sentry/version'

Gem::Specification.new do |spec|
  spec.name          = 'gruf-sentry'
  spec.version       = Gruf::Sentry::VERSION
  spec.authors       = ['Shaun McCormick']
  spec.email         = ['splittingred@gmail.com']
  spec.license       = 'MIT'

  spec.summary       = %q{Automatically report gruf failures as sentry errors}
  spec.description   = spec.summary
  spec.homepage      = 'https://github.com/bigcommerce/gruf-sentry'

  spec.required_ruby_version = '>= 2.7'

  spec.files         = Dir['README.md', 'CHANGELOG.md', 'CODE_OF_CONDUCT.md', 'lib/**/*', 'gruf-sentry.gemspec']
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler-audit', '~> 0.6'
  spec.add_development_dependency 'rake', '>= 12.3'
  spec.add_development_dependency 'rubocop', '>= 1.27'
  spec.add_development_dependency 'pry', '>= 0.14'
  spec.add_development_dependency 'rspec', '>= 3.8'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.4'
  spec.add_development_dependency 'simplecov', '>= 0.16'

  spec.add_dependency 'gruf', '~> 2.5', '>= 2.5.1'
  spec.add_dependency 'sentry-ruby', '>= 5.0'
end
