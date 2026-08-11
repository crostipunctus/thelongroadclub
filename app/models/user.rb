class User < ApplicationRecord
  has_secure_password

  has_many :discussions, dependent: :restrict_with_error
  has_many :posts, dependent: :restrict_with_error
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_discussions, through: :bookmarks, source: :discussion
  has_many :event_rsvps, dependent: :destroy
  has_many :attending_events, through: :event_rsvps, source: :event
  has_many :guides, dependent: :restrict_with_error
  has_many :garage_features, dependent: :nullify

  enum :role, { member: 0, moderator: 1, admin: 2 }

  validates :name, presence: true, length: { maximum: 80 }
  validates :username, presence: true, uniqueness: { case_sensitive: false },
                       format: { with: /\A[a-z0-9_]+\z/, message: "may only contain lowercase letters, numbers, and underscores" },
                       length: { in: 3..30 }
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :bio, length: { maximum: 500 }
  validates :avatar_color, inclusion: { in: %w[green ochre blue red] }

  before_validation :normalize_identity

  def initials
    name.split.first(2).filter_map { |part| part.first }.join.upcase
  end

  def to_param = username

  def can_moderate?
    moderator? || admin?
  end

  private

  def normalize_identity
    self.email = email.to_s.strip.downcase
    self.username = username.to_s.strip.downcase
  end
end
