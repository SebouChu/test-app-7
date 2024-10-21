class Post < ApplicationRecord
  attr_accessor :picture_delete

  has_one_attached :picture

  after_commit :purge_picture, on: :destroy

  private

  def purge_picture
    picture.purge if picture_delete == "1"
  end
end
