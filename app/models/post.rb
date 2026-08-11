class Post < ApplicationRecord
  belongs_to :discussion, counter_cache: :replies_count
  belongs_to :user
  belongs_to :parent, class_name: "Post", optional: true, inverse_of: :replies

  has_many :replies, class_name: "Post", foreign_key: :parent_id, inverse_of: :parent, dependent: :destroy

  validates :body, presence: true, length: { in: 2..10_000 }
  validate :parent_belongs_to_discussion
  validate :nesting_depth_is_supported

  after_create_commit :mark_discussion_active

  def editable_by?(actor)
    actor.present? && (actor == user || actor.can_moderate?)
  end

  def depth
    parent ? parent.depth + 1 : 0
  end

  private

  def mark_discussion_active
    discussion.update_column(:last_posted_at, created_at)
  end

  def parent_belongs_to_discussion
    return if parent.blank? || parent.discussion_id == discussion_id

    errors.add(:parent, "must belong to the same discussion")
  end

  def nesting_depth_is_supported
    errors.add(:parent, "cannot be nested more than three levels") if parent.present? && parent.depth >= 3
  end
end
