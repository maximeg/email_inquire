# EmailInquire

**Ruby** [![Gem Version](https://badge.fury.io/rb/email_inquire.svg)](https://badge.fury.io/rb/email_inquire)   [![Build Status](https://travis-ci.org/maximeg/email_inquire.svg?branch=master)](https://travis-ci.org/maximeg/email_inquire) [![codecov](https://codecov.io/gh/maximeg/email_inquire/branch/master/graph/badge.svg)](https://codecov.io/gh/maximeg/email_inquire) [![Code Climate](https://codeclimate.com/github/maximeg/email_inquire/badges/gpa.svg)](https://codeclimate.com/github/maximeg/email_inquire)

**dotnet** [![NuGet version](https://badge.fury.io/nu/EmailInquire.svg)](https://badge.fury.io/nu/EmailInquire)

EmailInquire is a library to validate email for format, common typos and one-time email providers.

[Changelog](https://github.com/maximeg/email_inquire/blob/master/CHANGELOG.md)

## Why?

Before a user is a user, they are a visitor. And they must register to be so. What if they makes a typo while
entering their email address during the registration ?
If they didn't notice, you just lost them. They won't be able to sign in next time.

Your users :

- may not be as tech savvy as you;
- may not remember exactly their email address;
- may make a typo while typing their email address (very very common on a mobile keyboard).

While we can't do so much for the name part of the email address, for the domain part, we can be smart!

And also, we don't want for users to use one-time email addresses (also called burner or disposable
email addresses).

## Supported cases

All supported cases are based on a static validation.
The gem does not check (yet) for domain existence (DNS) and prior delivery (MX entries on DNS).

### Email format

This doesn't strictly follow RFC 5322, it aims at validating email that will be
deliverable on Internet. It also takes into account length of email, name part and domain part as
per SMTP specification.

- `foo@domain..com` => invalid
- `foo@my..domain.com` => invalid
- `foo@my--domain.com` => invalid
- `foo@localhost` => invalid
- `foo@123.123.123.123` => invalid
- `secrétariat@domain.com` => invalid
- `foo+test@domain.com` => valid
- ...

### Typos

One char typo for 43 common email providers (worldwide and from France, United Kingdom and USA):

- `gmil.com` => hint `gmail.com`
- `hitmail.com` => hint `hotmail.com`
- `outloo.com` => hint `outlook.com`
- `virinmedia.com` => hint `virginmedia.com`
- ...

### ccTLD typos

ccTLD specificity, like United Kingdom `.xx.uk` domains:

- `foo.couk` => hint `foo.co.uk`
- `fooco.uk` => hint `foo.co.uk`
- `yahoo.uk` => hint `yahoo.co.uk`
- `foo.judiciary.uk` => ok!
- `foo.uk` => ok, .uk is open to registration
- ...

...and same thing with `.co.jp` & `.com.br` domains.

### Email provider

Providers with an unique domain:

- `gmail.fr` => hint `gmail.com`
- `gmail.de` => hint `gmail.com`
- `google.com` => hint `gmail.com`
- `free.com` => hint `free.fr`
- `laposte.com` => hint `laposte.net`
- `laposte.fr` => hint `laposte.net`
- ...

### Burners

4700 one-time email providers a.k.a. burners, or disposable email
([source](https://github.com/wesbos/burner-email-providers)):

- `yopmail.com` => invalid
- ...

### Known invalid domains

- `example.com` => invalid

### Custom invalid domains

Add your own invalid domains:

```ruby
# in config/initializers/email_inquire.rb
EmailInquire.custom_invalid_domains << "bad-domain.com"
```

- `bad-domain.com` => invalid

### Custom valid domains

Take precedence over all the above rules and make any domain in the list valid, and non hintable.
Add your own valid domains:

```ruby
# in config/initializers/email_inquire.rb
EmailInquire.custom_valid_domains << "good-domain.com"
```

- `good-domain.com` => valid

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

A custom invalid case:

```ruby
# in config/initializers/email_inquire.rb
EmailInquire.custom_invalid_domains << "bad-domain.com"
```

then:
```ruby
response = EmailInquire.validate("john.doe@bad-domain.com")
response.status   # :invalid
response.valid?   # false
response.invalid? # true
```

A custom valid case:

```ruby
# in config/initializers/email_inquire.rb
EmailInquire.custom_valid_domains << "example.com" # would be otherwise invalid
EmailInquire.custom_valid_domains << "sfr.com" # would be otherwise hinted to "sfr.fr"
```

then:
```ruby
response = EmailInquire.validate("john.doe@example.com")
response.status   # :valid
response.valid?   # true
response.invalid? # false

response = EmailInquire.validate("john.doe@sfr.com")
response.status   # :valid
response.valid?   # true
response.invalid? # false
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

## FAQ

### Why does a perfectly valid corporate domain is hinted ?

There are a few cases of corporate domains that will be hinted to the related public provider domain:

- `google.com` => hint `gmail.com`
- `laposte.fr` => hint `laposte.net`
- `sfr.com` => hint `sfr.fr`

This is intended. Taking `google.com` (corp) vs. `gmail.com` (public provider):

- there are far more people with a `gmail.com` address rather than people with `google.com` address;
- employees of Google are well aware of the difference between `google.com` (their employee address)
  and `gmail.com` (the public email provider offered by their company)
  and will not be mistaken by a hint;
- non-tech savvy people are not, and have in mind "my email address is google",
  so not hinting to `gmail.com` would let a lot of actual errors pass.

If you do not want this, add the affected domains to `EmailInquire.custom_valid_domains`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


### Mutation testing

We use [mutant](https://github.com/mbj/mutant) to ensure that everything is well
tested and the code is minimal. Coverage reported should be close to 100%.

Run it with:

```
bundle exec mutant --include lib --require 'email_inquire.rb' --use rspec -- 'EmailInquire*'
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/maximeg/email_inquire.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
