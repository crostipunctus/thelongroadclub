class Discussion < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :posts, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarking_users, through: :bookmarks, source: :user

  enum :status, { open: 0, locked: 1, archived: 2 }

  validates :title, presence: true, length: { in: 8..140 }
  validates :body, presence: true, length: { in: 20..20_000 }
  validates :slug, presence: true, uniqueness: true

  before_validation :set_slug, on: :create
  before_validation :set_last_posted_at, on: :create

  scope :visible, -> { where(status: statuses.values_at(:open, :locked)) }
  scope :fresh, -> { visible.order(pinned: :desc, last_posted_at: :desc) }
  scope :trending, -> { visible.order(Arel.sql("(replies_count * 4 + views_count) DESC")) }

  def to_param = slug

  def excerpt(length: 150)
    body.squish.truncate(length)
  end

  def record_view!
    increment!(:views_count)
  end

  def editable_by?(actor)
    actor.present? && (actor == user || actor.can_moderate?)
  end

  private

  def set_slug
    return if slug.present?

    base = title.to_s.parameterize
    candidate = base
    candidate = "#{base}-#{SecureRandom.hex(3)}" if self.class.exists?(slug: candidate)
    self.slug = candidate
  end

  def set_last_posted_at
    self.last_posted_at ||= Time.current
  end
end
