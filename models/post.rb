# frozen_string_literal: true

require './lib/hosts/const'
require './lib/image_cat'

class Post < ActiveRecord::Base
  # relations
  belongs_to :head, class_name: 'Post', inverse_of: :bodies
  has_many :bodies, class_name: 'Post', foreign_key: :head_id, inverse_of: :head
  # scopes
  default_scope { order(:number) }
  scope :today, -> { where('post_at > ?', Date.today.to_time) }
  scope :recent, -> { where('post_at > ?', Date.today.to_time - 7.days) }
  scope :on_date, lambda { |date = Date.today|
    where(post_at: (date.beginning_of_day..date.end_of_day))
  }
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

  def as_json(options = {})
    type = options.delete :type
    return super options if type != :homu
    options[:except] = %i[id kid head_id]
    json = super options
    json['id'] = kid
    json
  end

  def picture_url
    "#{Hosts::Const::HOMU_IMAGE}/src/#{picture}"
  end

  def cat_picture
    return if picture.blank?
    ImageCat.from_uri picture_url
  end
end
