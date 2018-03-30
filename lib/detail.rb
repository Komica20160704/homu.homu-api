class Detail
  attr_writer :picture, :content, :hiden_body_count

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
end
