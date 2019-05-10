class AddIndexPostsOnPostAt < ActiveRecord::Migration[5.2]
  def change
    add_index :posts, :post_at
  end
end
