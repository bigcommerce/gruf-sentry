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
module Gruf
  module Sentry
    ##
    # Mixin for error parsing
    #
    module ErrorParser
      ##
      # @param [StandardError]
      # @return [Number] that maps to one of the GRPC::Core::StatusCodes or Gruf::Sentry.default_error_code
      #
      def code_for(error)
        error.respond_to?(:code) ? error.code : Gruf::Sentry.default_error_code
      end

      ##
      # @return [Boolean]
      #
      def error?(exception)
        error_classes.include?(exception.class.to_s)
      end

      ##
      # @return [Array]
      #
      def error_classes
        @options.fetch(:error_classes, Gruf::Sentry.grpc_error_classes)
      end
    end
  end
end
