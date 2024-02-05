Changelog for the gruf-sentry gem.

### Pending release

- Add CI suite for Ruby 3.3

### 1.5.0

- Add support for Ruby 3.2
- Drop support for Ruby 2.7 (EOL March 2023)

### 1.4.0

* Remove `GRPC::FailedPrecondition` from default error classes (equivalent is HTTP 412, so not an internal error)
* Remove `Raven` compatibility layer; you must be on sentry-ruby now

### 1.3.0

* Upgrade to sentry-ruby 5.x

### 1.2.0

* Add Ruby 3.1 support
* Drop Ruby 2.6 support

### 1.1.0

* Update Gruf::Sentry::ClientInterceptor for new sentry-ruby format

### 1.0.1

* Update Sentry.capture_exception to work with new sentry-ruby format

### 1.0.0

* Update to sentry-ruby

### 0.2.0

* Add support for Ruby 3.0
* Remove support for < Ruby 2.6

### 0.1.1

* Fix issue with options reference in ErrorParser [#1]

### 0.1.0

* Initial release
