require "./lib/proxypay/version.rb"
require "httparty"

module Proxypay
  include HTTParty
  base_uri "api.proxypay.co.ao"

  # Fetch all available references
  def self.get_references(options={})
    auth = {
      username:ENV["PROXY_PAY_USER"],
      password:ENV["PROXY_PAY_PASSWORD"]
    }
    options = {basic_auth:auth}
    get('/references', options).parsed_response
  end

  # Submit a request to create a new reference
  def self.new_reference(amount, expiry_date)
    post('/references', :body =>{:reference => {:amount      => amount,
                                 :expiry_date => expiry_date}}.to_json,
                        :basic_auth => {:username => ENV["PROXY_PAY_USER"], :password => ENV["PROXY_PAY_PASSWORD"]},
                        :headers => { 'Content-Type' => 'application/json'}).parsed_response
  end

  # Fetch all availables payments
  def self.get_payments(options={})
    auth = {
      username:ENV["PROXY_PAY_USER"],
      password:ENV["PROXY_PAY_PASSWORD"]
    }
    options = {basic_auth:auth}
    get('/events/payments', options).parsed_response
  end
end

#ProxyPay.find(123)
