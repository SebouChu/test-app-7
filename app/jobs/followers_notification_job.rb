class FollowersNotificationJob < ApplicationJob
  queue_as :default

  def perform(post)
    puts "============================================="
    puts "@followers Hey! Post ##{id} has been updated!"
    puts "============================================="
  end
end