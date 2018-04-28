class Detail
  attr_writer :picture, :content, :hiden_body_count
  attr_reader :no

  def initialize matched_data
    @title = matched_data[1]
    @name = matched_data[2]
    @date = matched_data[3]
    @time = matched_data[4]
    @id = matched_data[5]
    @no = matched_data[6]
  end

  def to_hash
    hash = {}
    self.instance_variables.each do |var|
      hash_name = var.to_s
      hash_name.sub!('@', '').gsub!('_', '')
      hash_value = self.instance_variable_get var
      hash[hash_name.camelize] = hash_value if hash_value
    end
    return hash
  end

  def find_or_create_post
    post = Post.find_by(number: @no)
    return post if post.present?
    create_post
  end

  def create_post head_id = nil
    Post.create do |post|
      post.head_id = head_id
      post.title = @title
      post.name = @name
      post.name = @name
      post.post_at = Time.parse "#{@date}T#{@time}"
      post.kid = @id
      post.number = @no
      post.picture = @picture
      post.hidden_body_count = @hiden_body_count
      post.content = @content
    end
  end
end
