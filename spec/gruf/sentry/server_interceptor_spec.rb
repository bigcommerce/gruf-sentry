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
require 'spec_helper'

describe Gruf::Sentry::ServerInterceptor do
  let(:service) { ThingService.new }
  let(:options) { {} }
  let(:signature) { 'get_thing' }
  let(:active_call) { grpc_active_call }
  let(:grpc_method_name) { 'ThingService.get_thing' }
  let(:request) do
    double(
      :request,
      method_key: signature,
      service: ThingService,
      rpc_desc: nil,
      active_call: active_call,
      request_class: ThingRequest,
      service_key: 'thing_service.thing_request',
      message: grpc_request,
      method_name: grpc_method_name
    )
  end
  let(:errors) { Gruf::Error.new }
  let(:span) { double(:span, set_tag: true) }
  let(:interceptor) { described_class.new(request, errors, options) }

  describe '.call' do
    before do
      allow(request).to receive(:client_streamer?).and_return(false)
    end

    context 'when there is no error' do
      subject { interceptor.call { true } }

      it 'should not report the error' do
        expect(Raven).to_not receive(:capture_exception)
        expect { subject }.to_not raise_exception
      end
    end

    context 'when there is an exception' do
      let(:grpc_error_code) { :internal }
      let(:app_error_code) { :something_went_wrong }
      let(:exception_class) { StandardError }
      let(:error_message) { 'Something went wrong' }
      let(:exception) { exception_class.new(error_message) }

      subject do
        interceptor.call { interceptor.fail!(grpc_error_code, app_error_code, error_message) }
      end

      context 'and is a valid gRPC error' do
        it 'should ' do
          expect(::Raven).to receive(:capture_exception).once
          expect { subject }.to raise_error(GRPC::Internal)
        end
      end

      context 'with an ignored method' do
        before do
          allow(::Gruf::Sentry).to receive(:ignore_methods).and_return([grpc_method_name])
        end

        it 'should not report the error' do
          expect(Raven).to_not receive(:capture_exception)
          expect { subject }.to raise_error(GRPC::Internal)
        end
      end
    end
  end
end
