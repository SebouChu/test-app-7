class FollowersNotificationJob < ApplicationJob
  queue_as :default

  def perform(post)
    puts "============================================="
    puts "@followers Hey! Post ##{post.id} has been updated!"
    puts "============================================="
  end
end