class Category < ApplicationRecord
  COLORS = %w[green ochre blue red].freeze

  has_many :discussions, dependent: :restrict_with_error

  validates :name, :slug, presence: true
  validates :slug, uniqueness: true, format: { with: /\A[a-z0-9-]+\z/ }
  validates :color, inclusion: { in: COLORS }

  before_validation :set_slug, if: -> { slug.blank? && name.present? }

  default_scope { order(:position, :name) }

  private

  def set_slug
    self.slug = name.parameterize
  end
end
