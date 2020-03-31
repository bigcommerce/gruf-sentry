# frozen_string_literal: true

# Copyright (c) 2017-present, BigCommerce Pty. Ltd. All rights reserved
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
    # Intercepts inbound calls to provide Sentry error reporting
    #
    class ServerInterceptor < Gruf::Interceptors::ServerInterceptor
      include Gruf::Sentry::ErrorParser

      ##
      # Handle the gruf around hook and capture errors
      #
      def call(&_block)
        return yield if Gruf::Sentry.ignore_methods.include?(request.method_name)

        begin
          yield
        rescue StandardError, GRPC::BadStatus => e
          if error?(e) # only capture
            ::Raven.capture_exception(
              e,
              message: e.message,
              extra: {
                grpc_method: request.method_key,
                grpc_request_class: request.request_class,
                grpc_service_key: request.service_key,
                grpc_error_code: code_for(e),
                grpc_error_class: e.class
              }
            )
          end
          raise # passthrough
        end
      end

      private

      ##
      # @return [Hash]
      #
      def request_message_params
        return {} if request.client_streamer? || !request.message.respond_to?(:to_h)

        request.message.to_h
      end
    end
  end
end
