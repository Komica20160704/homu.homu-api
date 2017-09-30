class Detail
  def initialize matched_data
    @title = matched_data[1]
    @name = matched_data[2]
    @date = matched_data[3]
    @time = matched_data[4]
    @id = matched_data[5]
    @no = matched_data[6]
  end

  def Picture= value
    @picture = value
  end

  def Content= value
    @content = value
  end

  def HidenBodyCount= value
    @hidenBodyCount = value
  end

  def to_hash
    hash = {}
    self.instance_variables.each do |var|
      hash_name = var.to_s
      hash_name.sub!('@', '').capitalize!
      hash_value = self.instance_variable_get var
      hash[hash_name] = hash_value if hash_value
    end
    return hash
  end
end
