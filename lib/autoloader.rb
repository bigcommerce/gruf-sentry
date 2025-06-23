# frozen_string_literal: true

# use Zeitwerk to lazily autoload all the files in the lib directory
require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem(warn_on_extra_files: false)
loader.ignore(File.join(__dir__.to_s, 'gruf-sentry.rb'))
loader.setup
