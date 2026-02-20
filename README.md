# gruf-sentry - Sentry reporting for gruf

[![CircleCI](https://circleci.com/gh/bigcommerce/gruf-sentry/tree/main.svg?style=svg)](https://circleci.com/gh/bigcommerce/gruf-sentry/tree/main) [![Gem Version](https://badge.fury.io/rb/gruf-sentry.svg)](https://badge.fury.io/rb/gruf-sentry) [![Inline docs](http://inch-ci.org/github/bigcommerce/gruf-sentry.svg?branch=main)](http://inch-ci.org/github/bigcommerce/gruf-sentry)

Adds Sentry error reporting support for [gruf](https://github.com/bigcommerce/gruf) 2.7.0+
and [sentry-ruby](https://github.com/getsentry/sentry-ruby) 4.3+.

This gem will automatically report grpc failures and Gruf errors into Sentry as they happen in servers and clients.

## Installation

Simply install the gem:

```ruby
gem 'gruf-sentry'
```

Then after, in your gruf initializer:

```ruby
Gruf.configure do |c|
  c.interceptors.use(Gruf::Sentry::ServerInterceptor)
end
```

It comes with a few more options as well:

| Option             | Description                                                                                    | Default                                                                                                                         | ENV Key                          |
|--------------------|------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------|----------------------------------|
| ignore_methods     | A list of method names to ignore from logging. E.g. `['namespace.health.check']`               | `[]`                                                                                                                            | GRUF_SENTRY_IGNORE_METHODS       |
| grpc_error_classes | A list of gRPC error classes that will be used for detecting errors (as opposed to validation) | `GRPC::Unknown,GRPC::Internal,GRPC::DataLoss,GRPC::FailedPrecondition,GRPC::Unavailable,GRPC::DeadlineExceeded,GRPC::Cancelled` | GRUF_SENTRY_GRPC_ERROR_CLASSES   |
| default_error_code | The default gRPC error code to use (int value)                                                 | `GRPC::Core::StatusCodes::INTERNAL`                                                                                             | `GRUF_SENTRY_DEFAULT_ERROR_CODE` |

### Client Interceptors

To automatically report errors in your Gruf clients, pass the client interceptor to your `Gruf::Client` initializer:

```ruby
Gruf::Client.new(
  service: MyService,
  client_options: {
    interceptors: [Gruf::Sentry::ClientInterceptor.new]
  }
)
```

## License

Copyright (c) 2020-present, BigCommerce Pty. Ltd. All rights reserved

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit
persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
