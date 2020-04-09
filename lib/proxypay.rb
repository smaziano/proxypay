require "proxypay/version"
require "httparty"

module Proxypay
  include HTTParty
  debug_output $stdout
  base_uri "https://api.proxypay.co.ao"

  # Fetch all available references
  def self.get_references(options = {})
    set_base_url(options.delete(:is_test))
    content = set_headers(options)
    content[:query] = options.delete(:query) || {}
    get("/references", content).parsed_response
  end

  # Fetch a specific reference by his ID string
  def self.get_reference(id, options = {})
    set_base_url(options.delete(:is_test))
    content = set_headers(options)
    get("/references/#{id}", content).parsed_response
  end

  # Submit a request to create a new reference
  def self.new_reference(amount, expiry_date, options={})
    set_base_url(options.delete(:is_test))
    content = set_headers(options)
    content[:body] = {:reference => {:amount => amount.to_s, :expiry_date => expiry_date.to_s, custom_fields: (options.delete(:custom_fields) || {})}}.to_json
    post("/references", content).parsed_response
  end

  # Fetch all availables payments that have not been acknowledged.
  def self.get_payments(options={})
    set_base_url(options.delete(:is_test))
    content = set_headers(options)
    content[:query] = options.delete(:query) || {}
    get("/events/payments", content).parsed_response
  end

  # Acknowledge a payment by submitting his ID
  def self.new_payment(id, options = {})
    set_base_url(options.delete(:is_test))
    content = set_headers(options)
    delete("/events/payments/#{id}", content).parsed_response
  end

  # Acknowledge multiple payments by submitting an array of ids
  def self.new_payments(ids, options = {})
    set_base_url(options.delete(:is_test))
    content = set_headers(options)
    content[:body] = { :ids => ids }.to_json
    delete("/events/payments", content).parsed_response
  end

  # Get a list of customers
  def self.get_customers(options = {})
    set_base_url(options.delete(:is_test))
    content = set_headers(options)
    content[:query] = options.delete(:query) || {}
    get("/customers", content).parsed_response
  end

  # get a customer by id
  def self.get_customer(id, options = {})
    set_base_url(options.delete(:is_test))
    content = set_headers(options)
    get("/customers/#{id}", content).parsed_response
  end

  # Store a new customer or update one
  def self.new_customer(id, nome, telemovel, email, options = {})
    set_base_url(options.delete(:is_test))
    content = set_headers(options)
    content[:body] = {:customer => {:name => nome.to_s, :mobile => telemovel.to_s, :email => email.to_s}}.to_json
    put("/customers/#{id}", content).parsed_response
  end

  def self.set_base_url(is_test = false)
    self.base_uri is_test == true ? "https://api.sandbox.proxypay.co.ao" : "https://api.proxypay.co.ao"
  end

  private
  def self.set_headers(options)
    content = {}
    content[:basic_auth] = authenticate(options.delete(:api_key))
    content[:headers] = {'Content-Type' => 'application/json', 'Accept' => 'application/vnd.proxypay.v1+json'}
    return content
  end

  def self.authenticate(api_key = nil)
    auth = {
      username: api_key.nil? ? ENV["PROXYPAY_USER"] : 'api',
      password: api_key.nil? ? ENV["PROXYPAY_API_KEY"] : api_key
    }
    return auth
  end
end
