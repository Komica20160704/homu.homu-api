# frozen_string_literal: true

class Detail
  attr_writer :picture, :content, :hiden_body_count
  attr_reader :no

  def initialize(matched_data)
    @title, @name, @date, @time, @id, @no = matched_data
  end

  def to_hash
    hash = {}
    instance_variables.each do |var|
      hash_name = var.to_s
      hash_name.sub!('@', '').delete!('_')
      hash_value = instance_variable_get var
      hash[hash_name.camelize] = hash_value if hash_value
    end
    hash
  end

  def find_or_create_post
    post = Post.find_by(number: @no)
    return post if post.present?
    create_post
  end

  def create_post(head_post = nil)
    Post.create(head_id: head_post.try(:id),
                head_number: head_post.try(:number),
                title: @title,
                name: @name,
                post_at: Time.parse("#{@date}T#{@time}"),
                kid: @id,
                number: @no,
                picture: @picture,
                hidden_body_count: @hiden_body_count,
                content: @content)
  end
end
