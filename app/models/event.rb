class Event < ApplicationRecord
  has_many :event_rsvps, dependent: :destroy
  has_many :attendees, through: :event_rsvps, source: :user

  validates :title, :slug, :description, :location, :starts_at, presence: true
  validates :slug, uniqueness: true
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validate :ends_after_start

  before_validation :set_slug, on: :create

  scope :published, -> { where(published: true) }
  scope :upcoming, -> { where(starts_at: Time.current..).order(:starts_at) }

  def to_param = slug

  def full?
    capacity.present? && rsvps_count >= capacity
  end

  private

  def set_slug
    self.slug ||= title.to_s.parameterize
  end

  def ends_after_start
    errors.add(:ends_at, "must be after the start") if ends_at.present? && starts_at.present? && ends_at <= starts_at
  end
end
