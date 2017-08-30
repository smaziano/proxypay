# Proxypay

A ruby gem created by [SmartTechys](http://www.smarttechys.co.ao) for the [ProxyPay](http://www.proxypay.co.ao) API by [TimeBoxed](http://www.timeboxed.co.ao) that allows online payments using Angolan ATM's reference (Multicaixa references).

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

to make requests with another api_key use this on every method call.

```ruby
options = {api_key: your_api_key_obtained_from_proxypay_folks}
```



to make the request proxypay's test server use

```ruby
options = {is_test: true}
```


## Usage

### Use the class methods to get it going

## References
### Fetch all available references
```ruby
Proxypay.get_references # Fetch all references
Proxypay.get_references(api_key: some_api_key) # fetch using this key
Proxypay.get_references(is_test: true) # fetch from the test server

```
### Fetch references by using query's
or you can pass one or several query's parameters and even use the custom_fields defined at proxypay.
```ruby
options = {query: {status:"paid", offset:15, limit:13, q:{custom_fields:{your_fild:"some_data", some_other_filed:{that_takes:"an_hash"}}}}}
Proxypay.get_references(options)
```

### Fetch a reference by using id
```ruby
options = {}
Proxypay.get_reference(id, options)
```

### Request a new reference - amount and expiration_date for the reference are mandatory
```ruby
Proxypay.new_reference("2000.00", "2015-10-10")
```

### Request a reference and add custom fields to your reference for your identification.
```ruby
options = {custom_fields: {invoice:"001-2015", description:"Client #{client_number} - monthly payment"}}
Proxypay.new_reference("2000.00", "2015-10-10", options)
```

## Payments
### Fetch all payments that haven't been acknowledged
```ruby
Proxypay.get_payments
```
### Fetch all the payments with limitation by the specified number(quantity)
```ruby
options = {query: {n:48}}
Proxypay.get_payments(options)
```

### Fetch a specific payment by passing his ID
```ruby
options = {}
Proxypay.get_payment("OcSLBANU4tjRi9gfW5VUcMqkvzL", options)
```

### Acknowledge a payment by passing his ID
```ruby
options = {}
Proxypay.new_payment("OcSLBANU4tjRi9gfW5VUcMqkvzL", options)
```

### Acknowledge multiple payments by passing and array of ID's
```ruby
ids = ["OcSLBANU4tjRi9gfW5VUcMqkvzL", "EcJLBANU4trUi8gfM6MOcMqkvzH","VxELBANU4tjRi9gfW5VUcMqkvzZ"]
options = {}
Proxypay.new_payments(ids, options)
```

## Help and Docs
- [ProxyPay API](https://developer.proxypay.co.ao)
- [RDOC](http://www.rubydoc.info/gems/proxypay/0.2.2)

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
