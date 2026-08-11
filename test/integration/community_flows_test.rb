require "test_helper"

class CommunityFlowsTest < ActionDispatch::IntegrationTest
  setup do
    @user = create_user
    @category = create_category
    @discussion = create_discussion(user: @user, category: @category)
  end

  test "homepage and discussion JSON are backed by persisted records" do
    get root_path
    assert_response :success
    assert_includes response.body, @discussion.title

    get discussion_path(@discussion, format: :json)
    assert_response :success
    payload = JSON.parse(response.body)
    assert_equal @discussion.slug, payload["slug"]
    assert_equal @user.username, payload.dig("author", "username")
  end

  test "member can sign in and create a discussion" do
    sign_in(@user)
    assert_redirected_to root_path

    assert_difference "Discussion.count", 1 do
      post discussions_path, params: { discussion: { category_id: @category.id, title: "Where should the next club drive go?", body: "I would like route suggestions with road conditions and breakfast stops." } }
    end
    assert_redirected_to discussion_path(Discussion.order(:created_at).last)
  end

  test "guest is redirected before creating a discussion" do
    post discussions_path, params: { discussion: { category_id: @category.id, title: "A guest discussion title", body: "This should not be persisted without authentication." } }

    assert_redirected_to login_path
    assert_equal 1, Discussion.count
  end

  test "member can persist and remove a bookmark through JSON" do
    sign_in(@user)

    assert_difference "Bookmark.count", 1 do
      post discussion_bookmark_path(@discussion, format: :json)
    end
    assert_response :created
    assert JSON.parse(response.body)["bookmarked"]

    assert_difference "Bookmark.count", -1 do
      delete discussion_bookmark_path(@discussion, format: :json)
    end
    assert_response :success
  end

  test "member can post a nested reply" do
    parent = @discussion.posts.create!(user: @user, body: "A top-level comment to answer.")
    respondent = create_user
    sign_in(respondent)

    assert_difference "Post.count", 1 do
      post discussion_posts_path(@discussion), params: { post: { body: "This answer belongs beneath the first comment.", parent_id: parent.id } }
    end

    nested_reply = Post.order(:created_at).last
    assert_equal parent, nested_reply.parent
    assert_redirected_to discussion_path(@discussion, anchor: "post-#{nested_reply.id}")

    get discussion_path(@discussion)
    assert_response :success
    assert_select ".comment-children #post-#{nested_reply.id}", count: 1
  end

  test "newsletter subscription is idempotent" do
    assert_difference "NewsletterSubscription.count", 1 do
      post newsletter_subscriptions_path, params: { email: "reader@example.com" }
    end
    assert_redirected_to root_path

    assert_no_difference "NewsletterSubscription.count" do
      post newsletter_subscriptions_path, params: { email: "READER@example.com" }
    end
  end

  test "member can RSVP and cancel" do
    event = Event.create!(title: "Coastal breakfast run", description: "A relaxed club drive with breakfast at the end.", location: "Goa", starts_at: 3.days.from_now, published: true)
    sign_in(@user)

    assert_difference "EventRsvp.count", 1 do
      post event_rsvp_path(event), params: { status: "going" }
    end
    assert_redirected_to event_path(event)

    assert_difference "EventRsvp.count", -1 do
      delete event_rsvp_path(event)
    end
  end
end
