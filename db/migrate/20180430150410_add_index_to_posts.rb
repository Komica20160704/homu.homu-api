class AddIndexToPosts < ActiveRecord::Migration[5.1]
  def change
    add_index :posts, :kid
    add_index :posts, :number
  end
end
