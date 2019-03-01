ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

Stripe.api_key = ENV['SECRET_KEY']

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  setup do
    @user = users(:one)
    @campaign = campaigns(:one)
  end

  # Create a US bank token
  def create_bank_token
    @btok = Stripe::Token.create(
      bank_account: {
        country: "US",
        currency: "usd",
        routing_number: "110000000",
        account_number: "000123456789"
      }
    )
  end

  # Create a Stripe account to use for tests
  def create_stripe_account
    @stripe_account = Stripe::Account.create(
      type: 'custom',
      requested_capabilities: ['platform_payments'], # Donors interact with the platform
      business_type: 'company',
      company: {
        name: 'Snookies Cookies',
        tax_id: '000000000',
      },
      business_profile: {
        product_description: 'Fundraising campaign',
      },
      tos_acceptance: {
        date: Time.now.to_i,
        ip: '1.2.3.4'
      },
    )
  end
end
