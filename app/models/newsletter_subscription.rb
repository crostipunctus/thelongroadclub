class NewsletterSubscription < ApplicationRecord
  enum :status, { active: 0, unsubscribed: 1 }

  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: URI::MailTo::EMAIL_REGEXP }

  before_validation { self.email = email.to_s.strip.downcase }
end
