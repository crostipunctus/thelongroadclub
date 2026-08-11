class EventRsvp < ApplicationRecord
  belongs_to :event, counter_cache: :rsvps_count
  belongs_to :user

  enum :status, { going: 0, interested: 1 }

  validates :user_id, uniqueness: { scope: :event_id }
  validate :event_has_space, on: :create

  private

  def event_has_space
    errors.add(:event, "is full") if going? && event&.full?
  end
end
