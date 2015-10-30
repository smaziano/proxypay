require "./lib/proxypay/version.rb"
require "httparty"

module Proxypay
  include HTTParty
  base_uri "api.proxypay.co.ao"

  # Fetch all available references
  def self.get_references(options={})
    options = {:basic_auth => authenticate}
    get('/references', options).parsed_response
  end

  # Submit a request to create a new reference
  def self.new_reference(amount, expiry_date, other_data={})
    post('/references',
      :body =>{ :reference => {:amount => amount, :expiry_date => expiry_date, :custom_fields => other_data } }.to_json,
      :basic_auth => authenticate,
      :headers => { 'Content-Type' => 'application/json'}).parsed_response
  end

  # Fetch all availables payments
  def self.get_payments(options={})
    options = {:basic_auth => authenticate}
    get('/events/payments', options).parsed_response
  end

  private
  def self.authenticate
    auth = {
      username:ENV["PROXY_PAY_USER"],
      password:ENV["PROXY_PAY_PASSWORD"]
    }
  end
end

#ProxyPay.find(123)
