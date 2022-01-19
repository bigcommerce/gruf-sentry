# frozen_string_literal: true

# Copyright (c) 2022-present, BigCommerce Pty. Ltd. All rights reserved
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
require 'spec_helper'

describe Gruf::Sentry::ClientInterceptor do
  let(:options) { {} }
  let(:signature) { 'get_thing' }
  let(:active_call) { grpc_active_call }
  let(:grpc_method_name) { 'ThingService.get_thing' }
  let(:request) do
    double(
      :request,
      method_key: signature,
      route_key: 'foo',
      type: 'bar',
      service: ThingService,
      rpc_desc: nil,
      active_call: active_call,
      request_class: ThingRequest,
      service_key: 'thing_service.thing_request',
      message: grpc_request,
      method_name: grpc_method_name
    )
  end
  let(:interceptor) { described_class.new(options) }

  describe '.call' do
    context 'when there is no error' do
      subject { interceptor.call(request_context: request) { true } }

      it 'should not report the error' do
        expect(::Sentry).to_not receive(:capture_exception)
        expect { subject }.to_not raise_exception
      end
    end

    context 'when there is an exception' do
      let(:exception_class) { GRPC::Internal }
      let(:error_message) { 'Something went wrong' }
      let(:exception) { exception_class.new(error_message) }

      subject do
        interceptor.call(request_context: request) { raise exception }
      end

      context 'and is a valid gRPC error' do
        it 'should ' do
          expect(::Sentry).to receive(:capture_exception).once.and_call_original
          expect { subject }.to raise_error(GRPC::Internal)
        end
      end

      context 'with an ignored method' do
        before do
          allow(::Gruf::Sentry).to receive(:ignore_methods).and_return([grpc_method_name])
        end

        it 'should not report the error' do
          expect(::Sentry).to_not receive(:capture_exception)
          expect { subject }.to raise_error(GRPC::Internal)
        end
      end
    end
  end
end
