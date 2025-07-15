# frozen_string_literal: true

# use Zeitwerk to lazily autoload all the files in the lib directory
require 'zeitwerk'
lib_dir = __dir__.to_s
loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.inflector.inflect('version' => 'VERSION')
loader.ignore(
  File.join(lib_dir, 'gruf-sentry.rb'),
  File.join(lib_dir, 'autoloader.rb')
)
loader.setup
