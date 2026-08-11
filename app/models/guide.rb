class Guide < ApplicationRecord
  belongs_to :user

  validates :title, :slug, :section, :summary, :body, presence: true
  validates :slug, uniqueness: true
  validates :read_time_minutes, numericality: { only_integer: true, greater_than: 0 }

  before_validation :set_slug, on: :create

  scope :published, -> { where.not(published_at: nil).where(published_at: ..Time.current).order(published_at: :desc) }

  def to_param = slug

  private

  def set_slug
    self.slug ||= title.to_s.parameterize
  end
end
