class Micropost < ApplicationRecord
  belongs_to :user, optional: true

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  validate :picture_size

  scope :following, -> id {where("user_id IN
    (SELECT followed_id FROM relationships
    WHERE  follower_id = :user_id)
    OR user_id = :user_id", user_id: id)}

  def picture_size
    if picture.size > 5.megabytes
      errors.add :picture, "should be less than 5MB"
    end
  end
end
