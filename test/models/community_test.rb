require "test_helper"

class CommunityTest < ActiveSupport::TestCase
  test "user identity is normalized and password authenticates" do
    user = create_user(email: "  DRIVER@EXAMPLE.COM ", username: "Road_Driver")

    assert_equal "driver@example.com", user.email
    assert_equal "road_driver", user.username
    assert user.authenticate("longroad2026")
    assert_not user.authenticate("wrong-password")
  end

  test "discussion creates a friendly slug and post updates counters" do
    discussion = create_discussion

    assert_equal "a-properly-detailed-discussion-title", discussion.slug
    assert_difference -> { discussion.reload.replies_count }, 1 do
      discussion.posts.create!(user: discussion.user, body: "A useful follow-up reply.")
    end
  end

  test "a discussion can only be bookmarked once per member" do
    discussion = create_discussion
    Bookmark.create!(user: discussion.user, discussion: discussion)

    duplicate = Bookmark.new(user: discussion.user, discussion: discussion)
    assert_not duplicate.valid?
  end

  test "replies can nest only inside their own discussion" do
    discussion = create_discussion
    parent = discussion.posts.create!(user: discussion.user, body: "A top-level comment.")
    child = discussion.posts.create!(user: create_user, parent: parent, body: "A properly nested reply.")

    assert_equal 1, child.depth
    assert_equal [ child ], parent.replies

    other_discussion = create_discussion
    invalid_reply = other_discussion.posts.new(user: other_discussion.user, parent: parent, body: "This crosses discussion boundaries.")
    assert_not invalid_reply.valid?
    assert_includes invalid_reply.errors[:parent], "must belong to the same discussion"
  end

  test "event capacity prevents additional going RSVPs" do
    event = Event.create!(title: "Dawn run", description: "A careful early morning community drive.", location: "Pune", starts_at: 2.days.from_now, capacity: 1, published: true)
    EventRsvp.create!(event: event, user: create_user)

    second = EventRsvp.new(event: event, user: create_user)
    assert_not second.valid?
    assert_includes second.errors[:event], "is full"
  end
end
