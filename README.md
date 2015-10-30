# Proxypay

A ruby gem to connect your application with [ProxyPay](http://www.proxypay.co.ao) API that allows your application to interact with the Angolan ATM system knows as Multicaixa for online payments by reference.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'proxypay'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install proxypay

## Setup
Make sure you setup the environment variables PROXYPAY_USER and PROXYPAY_API_KEY:

```ruby
PROXYPAY_USER=api
PROXYPAY_API_KEY=your_api_key_obtained_from_proxypay_folks
```

## Usage

```ruby
## Use the class methods to get it going

# References
## Fetch all available references
Proxypay.get_references

## Request a new reference - amount and expiration_date for the reference are mandatory
Proxypay.new_reference("2000.00", "2015-10-10")

## Request a reference and add custom fields to your reference for your identification.
other_data = {invoice:"001-2015", description:"Client #{client_number} - monthly payment"}
Proxypay.new_reference("2000.00", "2015-10-10", other_data)

# Payments
## Fetch all payments that haven't been acknowledged
Proxypay.get_payments

## Fetch a specific payment by passing his ID
Proxypay.get_payment("OcSLBANU4tjRi9gfW5VUcMqkvzL")

## Acknowledge a payment by passing his ID
Proxypay.new_payment("OcSLBANU4tjRi9gfW5VUcMqkvzL")
```
work in progress...

## Help and Docs for Proxypay API and proxypay gem
- [ProxyPay API](https://developer.proxypay.co.ao)
- [RDOC](http://www.rubydoc.info/gems/proxypay/0.1.1)

## Development
- You can fork the project
- bundle
- bundle rake exec
- Make your feature addition or fix a bug
- Do not mess with rakefile, version or history (do not submit version bump PLEASE or put it in a different commit so we can ignore it when pull)
- Send us the pull request

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/smaziano/proxypay. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

