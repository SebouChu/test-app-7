class Post < ApplicationRecord
  attr_accessor :picture_delete
  attr_accessor :notify_followers

  has_one_attached :picture

  after_commit :purge_picture, on: :destroy
  after_commit :send_notification_to_followers

  private

  def purge_picture
    picture.purge if picture_delete == "1"
  end

  def send_notification_to_followers
    if notify_followers == "1"
      puts "============================================="
      puts "@followers Hey! Post ##{id} has been updated!"
      puts "============================================="
    end
  end
end
