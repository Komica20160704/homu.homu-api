class AddIndexToPostsOnHeadNumber < ActiveRecord::Migration[5.2]
  def change
    add_index :posts, :head_number
  end
end
