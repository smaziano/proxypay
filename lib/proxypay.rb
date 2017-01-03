#require "./lib/proxypay/version.rb"
require "proxypay/version"
require "httparty"

module Proxypay
  include HTTParty
  base_uri "https://api.proxypay.co.ao"

  # Fetch all available references
  def self.get_references(options={})
    # request body and header
    content = {}
    auth = {:basic_auth => authenticate}
    body = {:headers => {'Content-Type' => 'application/json'}}
    content.merge!(auth)
    content.merge!(body)
    # request query options
    options = {limit: 20, offset: 0, status: nil, q: nil}.merge!(options)
    # query options
    case options != nil
      # get refs with provided status w/o specific custom query
      when options.fetch(:status) != nil && options.fetch(:q) == nil
        get("/references?limit=#{options[:limit]}&offset=#{options[:offset]}&status=#{options[:status]}", content).parsed_response
      # get refs with provided custom query with specifc status
      when options.fetch(:status) != nil && options.fetch(:q) != nil
        get("/references?q=#{options[:q]}&limit=#{options[:limit]}&offset=#{options[:offset]}&status=#{options[:status]}", content).parsed_response
      # get refs with provided custom query w/o providing specific status
      when options.fetch(:status) == nil && options.fetch(:q) != nil
        get("/references?q=#{options[:q]}&limit=#{options[:limit]}&offset=#{options[:offset]}", content).parsed_response
      else
        # just get all the reference as per the api defaults (when there is no args provided)
        get("/references", content).parsed_response
      end
  end

  # Fetch a specific reference by his ID string
  def self.get_reference(id)
    options = {:basic_auth => authenticate}
    get("/references/#{id}", options).parsed_response
  end

  # Submit a request to create a new reference
  def self.new_reference(amount, expiry_date, other_data={})
    post("/references",
      :body =>{ :reference => {:amount => amount, :expiry_date => expiry_date, :custom_fields => other_data } }.to_json,
      :basic_auth => authenticate,
      :headers => { 'Content-Type' => 'application/json'}).parsed_response
  end

  # Submit a request to create a new reference on behalf of other API_KEY
  def self.other_new_reference(amount, expiry_date, other_data={}, api_key)
    auth = {
      username:"api",
      password:"#{api_key}"
    }
    post("/references",
      :body =>{ :reference => {:amount => amount, :expiry_date => expiry_date, :custom_fields => other_data } }.to_json,
      :basic_auth => auth,
      :headers => { 'Content-Type' => 'application/json'}).parsed_response
  end

  # Fetch all the payments that have not been acknoledged (by submiting the api key)
  def self.other_get_payments(api_key)
    auth = {
      username:"api",
      password:"#{api_key}"
    }
    options = {:basic_auth => auth}
    get("/events/payments", options).parsed_response
  end

  # Fetch all availables payments that have not been acknowledged.
  def self.get_payments(options={})
    # request body and header
    content = {}
    auth = {:basic_auth => authenticate}
    body = {:headers => {'Content-Type' => 'application/json'}}
    content.merge!(auth)
    content.merge!(body)

    # request query options
    options = {n: nil}.merge!(options)
    if options.fetch(:n) == nil
      # get payments without providing any number(quantity)
      get("/events/payments", content).parsed_response
    else
      # get payments with based on the number(quantity) provided
      get("/events/payments?n=#{options[:n]}", content).parsed_response
    end
  end

  # Acknowledge a payment by submitting his ID
  def self.new_payment(id)
    options = {:basic_auth => authenticate}
    delete("/events/payments/#{id}", options).parsed_response
  end

  # Acknowledge a payment by submitting his ID and the API KEY
  def self.other_new_payment(id, api_key)
    auth = {
      username:"api",
      password:"#{api_key}"
    }
    options = {:basic_auth => auth}
    delete("/events/payments/#{id}", options).parsed_response
  end

  # Acknowledge multiple payments by submitting an array of ids
  def self.new_payments(ids)
    delete("/events/payments", :body => { :ids => ids }.to_json, :basic_auth => authenticate, :headers => { 'Content-Type' => 'application/json'} ).parsed_response
  end

  private
  def self.authenticate
    auth = {
      username:ENV["PROXYPAY_USER"],
      password:ENV["PROXYPAY_API_KEY"]
    }
    return auth
  end
end
