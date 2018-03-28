class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.integer :head_id, index: true
      t.string :title
      t.string :name
      t.datetime :post_at
      t.string :kid
      t.string :number
      t.string :picture
      t.integer :hidden_body_count
      t.text :content
    end
  end
end
