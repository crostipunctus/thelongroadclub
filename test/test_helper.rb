ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module TestData
  def create_user(overrides = {})
    token = SecureRandom.hex(4)
    User.create!({
      name: "Test Driver", username: "driver_#{token}", email: "driver_#{token}@example.com",
      password: "longroad2026", password_confirmation: "longroad2026"
    }.merge(overrides))
  end

  def create_category(overrides = {})
    token = SecureRandom.hex(3)
    Category.create!({ name: "Road Trips #{token}", slug: "road-trips-#{token}", color: "ochre" }.merge(overrides))
  end

  def create_discussion(user: create_user, category: create_category, overrides: {})
    Discussion.create!({
      user: user, category: category, title: "A properly detailed discussion title",
      body: "This is a useful discussion body with enough detail for the community."
    }.merge(overrides))
  end

  def sign_in(user, password: "longroad2026")
    post session_path, params: { email: user.email, password: password }
  end
end

class ActiveSupport::TestCase
  include TestData
end

class ActionDispatch::IntegrationTest
  include TestData
end
