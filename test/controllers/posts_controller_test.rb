require "test_helper"

class PostsControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test "should create without picture" do
    assert_no_enqueued_jobs only: FollowersNotificationJob do
      post(posts_url, params: { post: {
        title: "A new post",
        body: "This is the body of the new post"
      } })
    end
  end

  test "should create without picture and notify followers" do
    assert_enqueued_jobs 1, only: FollowersNotificationJob do
      post(posts_url, params: { post: {
        title: "A new post",
        body: "This is the body of the new post",
        notify_followers: "1"
      } })
    end
  end

  test "should create with uploaded picture" do
    assert_no_enqueued_jobs only: FollowersNotificationJob do
      post(posts_url, params: { post: {
        title: "A new post",
        body: "This is the body of the new post",
        picture: fixture_file_upload("lachlan-gowen.jpg", "image/jpeg")
      } })
    end
    assert(Post.last.picture.attached?)
  end

  test "should create with uploaded picture and notify followers" do
    assert_enqueued_jobs 1, only: FollowersNotificationJob do
      post(posts_url, params: { post: {
        title: "A new post",
        body: "This is the body of the new post",
        picture: fixture_file_upload("lachlan-gowen.jpg", "image/jpeg"),
        notify_followers: "1"
      } })
    end
    assert(Post.last.picture.attached?)
  end

  test "should create with direct-uploaded picture and notify followers" do
    blob = directly_upload_file_blob(filename: "lachlan-gowen.jpg", content_type: "image/jpeg", record: nil)
    assert_enqueued_jobs 1, only: FollowersNotificationJob do
      post(posts_url, params: { post: {
        title: "A new post",
        body: "This is the body of the new post",
        picture: blob.signed_id,
        notify_followers: "1"
      } })
    end
    assert(Post.last.picture.attached?)
  end
end
