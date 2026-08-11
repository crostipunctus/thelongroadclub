class GarageFeature < ApplicationRecord
  belongs_to :user, optional: true

  validates :owner_name, :slug, :title, :summary, :story, :car_year, :car_make, :car_model, :city, presence: true
  validates :slug, uniqueness: true
  validates :car_year, numericality: { only_integer: true, in: 1886..(Time.current.year + 1) }

  before_validation :set_slug, on: :create

  scope :published, -> { where.not(published_at: nil).where(published_at: ..Time.current) }

  def to_param = slug
  def car_name = "#{car_year} #{car_make} #{car_model}"

  private

  def set_slug
    self.slug ||= "#{car_year}-#{car_make}-#{car_model}-#{owner_name}".parameterize
  end
end
