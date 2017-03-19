# EmailInquire

[![Gem Version](https://badge.fury.io/rb/email_inquire.svg)](https://badge.fury.io/rb/email_inquire) [![Build Status](https://travis-ci.org/maximeg/email_inquire.svg?branch=master)](https://travis-ci.org/maximeg/email_inquire)

EmailInquire is a library to validate email for common typos and one-time email providers.

## Why?

Before an user is an user, it's a visitor. And he must register to be so. What if he makes a typo while
entering its email address during the registration ?
If he didn't notice, you just lost him. He won't be able to sign in next time.

Your users :

- may not be as tech saavy as you;
- may not remember exactly their email address;
- may make a typo while typing their email address (very very common on a mobile keyboard).

While we can't do so much for the name part of the email address, for the domain part, we can be smart!

And also, we don't want for users to use one-time email addresses (also called burner email addresses).

### Supported cases

One char typo for 43 common email providers of France, United Kingdom and USA:

- `gmil.com` => hint `gmail.com`
- `hitmail.com` => hint `hotmail.com`
- `outloo.com` => hint `outlook.com`
- `virinmedia.com` => hint `virginmedia.com`
- ...

United Kingdom `.xx.uk` domains:

- `foo.couk` => hint `foo.co.uk`
- `fooco.uk` => hint `foo.co.uk`
- `foo.uk` => hint `foo.co.uk`
- `foo.judiciary.uk` => ok!
- ...

Providers with an unique domain:

- `gmail.fr` => hint `gmail.com`
- `gmail.de` => hint `gmail.com`
- `google.com` => hint `gmail.com`
- `free.com` => hint `free.fr`
- `laposte.com` => hint `laposte.net`
- `laposte.fr` => hint `laposte.net`
- ...

One-time email providers (a.k.a. burners):

- `yopmail.com` => invalid
- more to come for v0.2.0

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'email_inquire'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install email_inquire

## Usage

Use `EmailInquire.validate(email)`, you'll get a `EmailInquire::Response` that represents weither
or not the email address is valid or may contain a mistake.

Methods of `EmailInquire::Response`:

| Method | Description | Possible values |
| --- | --- | --- |
| `#email` | The validated email address | `"john.doe@gnail.com"` |
| `#status` | The status of the validation | `:valid` `:invalid` or `:hint` |
| `#valid?` | Is the email valid ? | `true` or `false` |
| `#invalid?` | Is the email invalid ? | `true` or `false` |
| `#hint?` | Is there a possible mistake and you have to show a hint to the user ? | `true` or `false` |
| `#replacement` | A proposal replacement email address for when status is `:hint` | `"john.doe@gmail.com"` or nil |

### Examples

A valid case:

```ruby
response = EmailInquire.validate("john.doe@gmail.com")
response.status # :valid
response.valid? # true
```

An invalid case:

```ruby
response = EmailInquire.validate("john.doe@yopmail.com")
response.status   # :invalid
response.valid?   # false
response.invalid? # true
```

A hint case:

```ruby
response = EmailInquire.validate("john.doe@gmail.co")
response.status      # :hint
response.valid?      # false
response.hint?       # true
response.replacement # "john.doe@gmail.com"
```

### Hint

I think it's important to just offer a hint to the user and to not automatically replace the
**maybe** faulty email address in the form.

A _"Did you mean xxx@yyy.zzz ?"_ has the following advantages:

- user remains in charge: we could have hinted against a perfectly valid email;
- user is educated;
- mini whaoo effect;

This _"Did you mean xxx@yyy.zzz ?"_ is better being actionable, and appearing to be so: a click or
tap on it should replace the email by the suggestion.

```
  +---------------------------------------+  +---------+
  | john.doe@yaho.com                     |  | Sign Up |
  +---------------------------------------+  +---------+
    Did you mean john.doe@yahoo.com ?
```

Note that you could even have this validation for your Sign In form...

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/maximeg/email_inquire.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

