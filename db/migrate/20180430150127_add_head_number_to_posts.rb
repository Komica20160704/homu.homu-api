class AddHeadNumberToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :head_number, :string
  end
end
