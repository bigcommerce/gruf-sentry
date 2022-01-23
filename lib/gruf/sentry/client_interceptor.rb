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
    # Intercepts outbound calls to provide Sentry reporting
    #
    class ClientInterceptor < Gruf::Interceptors::ClientInterceptor
      include Gruf::Sentry::ErrorParser

      ##
      # @param [Gruf::Outbound::RequestContext]
      #
      def call(request_context:)
        return yield if Gruf::Sentry.ignore_methods.include?(request_context.method_name)

        begin
          yield
        rescue StandardError, GRPC::BadStatus => e
          if error?(e) # only capture
            ::Sentry.configure_scope do |scope|
              scope.set_transaction_name(request_context.route_key)
              scope.set_tags(grpc_method_name: request_context.method_name,
                             grpc_route_key: request_context.route_key,
                             grpc_call_type: request_context.type,
                             grpc_error_code: code_for(e),
                             grpc_error_class: e.class.name)
            end
            ::Sentry.capture_exception(e)
          end
          raise # passthrough
        end
      end
    end
  end
end
