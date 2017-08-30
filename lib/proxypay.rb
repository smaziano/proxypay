#require "./lib/proxypay/version.rb"
require "proxypay/version"
require "httparty"

module Proxypay
  include HTTParty
  base_uri "https://api.proxypay.co.ao"

  # Fetch all available references
  def self.get_references(options = {})
    # Proxypay.get_references(query: {limit: 20}, is_test: true, api_key: '0djwano5yth94ihrtw34ot9cehn9emo')
    set_base_url(options.delete(:is_test))
    # request body and header
    content = {}
    content[:basic_auth] = authenticate(options.delete(:api_key))
    content[:headers] = {'Content-Type' => 'application/json'}
    content[:query] = options.delete(:query) || {}
    get("/references", content).parsed_response
  end

  # Fetch a specific reference by his ID string
  def self.get_reference(id, options = {})
    set_base_url(options.delete(:is_test))
    options = {:basic_auth => authenticate(options.delete(:api_key))}
    get("/references/#{id}", options).parsed_response
  end

  # Submit a request to create a new reference
  def self.new_reference(amount, expiry_date, options={})
    # new_reference(78654.90, '12-12-2012', custom_fields: {foo: 'F0000-45', bar: 'MMM'}, api_key: 'ctsrxte56v8my_keyv7fuf676t7o89099y85ce6f', is_test: true)
    set_base_url(options.delete(:is_test))
    content = {}
    content[:basic_auth] = authenticate(options.delete(:api_key))
    content[:body] = {:reference => {:amount => amount, :expiry_date => expiry_date, custom_fields: (options.delete(:custom_fields) || {})}}.to_json
    content[:headers] = {'Content-Type' => 'application/json'}
    post("/references", content).parsed_response
  end

  # Fetch all availables payments that have not been acknowledged.
  def self.get_payments(options={})
    # Proxypay.get_payments(query: {limit: 20}, is_test: true, api_key: '0djwano5yth94ihrtw34ot9cehn9emo')
    set_base_url(options.delete(:is_test))
    # request body and header
    content = {}
    content[:basic_auth] = authenticate(options.delete(:api_key))
    content[:headers] = {'Content-Type' => 'application/json'}
    content[:query] = options.delete(:query) || {}
    get("/events/payments", content).parsed_response
  end

  # Acknowledge a payment by submitting his ID
  def self.new_payment(id, options = {})
    set_base_url(options.delete(:is_test))
    content = {:basic_auth => authenticate(options.delete(:api_key))}
    delete("/events/payments/#{id}", content).parsed_response
  end

  # Acknowledge multiple payments by submitting an array of ids
  def self.new_payments(ids, options = {})
    set_base_url(options.delete(:is_test))
    content = {}
    content[:body] = { :ids => ids }.to_json
    content[:basic_auth] = authenticate(options.delete(:api_key))
    content[:headers] = {'Content-Type' => 'application/json'}
    delete("/events/payments", content).parsed_response
  end

  def self.set_base_url(is_test = false)
    self.base_uri is_test == true ? "https://api.proxypay.co.ao/tests" : "https://api.proxypay.co.ao"
  end

  private
  def self.authenticate(api_key = nil)
    auth = {
      username: api_key.nil? ? ENV["PROXYPAY_USER"] : 'api',
      password: api_key.nil? ? ENV["PROXYPAY_API_KEY"] : api_key
    }
    return auth
  end
end
