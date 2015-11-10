#require "./lib/proxypay/version.rb"
require "proxypay/version"
require "httparty"

module Proxypay
  include HTTParty
  base_uri "api.proxypay.co.ao"

  # Fetch all available references
  def self.get_references(options={})
    options = {:basic_auth => authenticate}
    get("/references", options).parsed_response
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

  # Fetch all availables payments that have not been acknowledged.
  def self.get_payments(options={})
    options = {:basic_auth => authenticate}
    get("/events/payments", options).parsed_response
  end

  # Acknowledge a payment by submitting his ID
  def self.new_payment(id)
    delete("/events/payments/#{id}", :basic_auth => authenticate).parsed_response
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
