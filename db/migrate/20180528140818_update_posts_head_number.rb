class UpdatePostsHeadNumber < ActiveRecord::Migration[5.1]
  def up
    Post.where(head_id: nil).find_each do |post|
      post.head_number = post.number
      post.save!
    end
  end

  def down
    Post.where(head_id: nil).update_all(head_number: nil)
  end
end
