class Post < ActiveRecord::Base
  belongs_to :head, class_name: 'Post', inverse_of: :bodies
  has_many :bodies, class_name: 'Post', foreign_key: :head_id, inverse_of: :head

  def is_head?
    head_id.blank?
  end

  def is_body?
    head_id.present?
  end
end
