# frozen_string_literal: true

class Post < ActiveRecord::Base
  # relations
  belongs_to :head, class_name: 'Post', inverse_of: :bodies
  has_many :bodies, class_name: 'Post', foreign_key: :head_id, inverse_of: :head
  # scopes
  default_scope { order(:number) }
  scope :today, -> { where('post_at > ?', Date.today.to_time) }
  scope :recent, -> { where('post_at > ?', Date.today.to_time - 7.days) }
  # callbacks
  after_find do |post|
    post.post_at = post.post_at.in_time_zone Time.zone
  end
  # kaminari
  paginates_per 10
  max_paginates_per 20

  def head?
    head_id.blank?
  end

  def body?
    head_id.present?
  end
end
