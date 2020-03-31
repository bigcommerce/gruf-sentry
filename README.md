# gruf-sentry - Sentry reporting for gruf

[![CircleCI](https://circleci.com/gh/bigcommerce/gruf-sentry/tree/master.svg?style=svg&circle-token=271adb0c4e7bdb76a427b47fd9bfd6f988170932)](https://circleci.com/gh/bigcommerce/gruf-sentry/tree/master) [![Gem Version](https://badge.fury.io/rb/gruf-sentry.svg)](https://badge.fury.io/rb/gruf-sentry) [![Inline docs](http://inch-ci.org/github/bigcommerce/gruf-sentry.svg?branch=master)](http://inch-ci.org/github/bigcommerce/gruf-sentry)

Adds Sentry error reporting support for [gruf](https://github.com/bigcommerce/gruf) 2.7.0+.

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

| Option | Description | Default |
| ------ | ----------- | ------- |
| ignore_methods | An array of method names to ignore from logging. E.g. `['namespace.health.check']` | `[]` |

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
