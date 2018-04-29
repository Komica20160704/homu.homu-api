class Post < ActiveRecord::Base
  default_scope { order(:number) }
  scope :today, -> { where('post_at > ?', Date.today.to_time) }
  scope :this_week, -> { where('post_at > ?', Date.today.to_time - 7.days) }

  belongs_to :head, class_name: 'Post', inverse_of: :bodies
  has_many :bodies, class_name: 'Post', foreign_key: :head_id, inverse_of: :head

  paginates_per 10
  max_paginates_per 20

  after_find do |post|
    post.post_at = post.post_at.in_time_zone Time.zone
  end

  def is_head?
    head_id.blank?
  end

  def is_body?
    head_id.present?
  end
end
