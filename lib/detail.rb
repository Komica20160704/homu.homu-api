# frozen_string_literal: true

class Detail
  attr_writer :picture, :content, :hiden_body_count
  attr_reader :no

  def initialize(matched_data = [])
    @title, @name, @date, @time, @id, @no = matched_data
  end

  def self.from_hash(hash)
    detail = Detail.new
    hash.each do |key, value|
      var = key.underscore.prepend('@').to_sym
      detail.instance_variable_set var, value
    end
    detail
  end

  def to_hash
    hash = {}
    instance_variables.each do |var|
      hash_value = instance_variable_get var
      next unless hash_value
      key = var.to_s.delete('@').camelize
      hash[key] = hash_value
    end
    hash
  end

  def create_post(head_post = nil)
    Post.create(head_id: head_post.try(:id),
                head_number: head_post.try(:number) || @no,
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
