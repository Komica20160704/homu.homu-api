class InitialPostsHeadNumber < ActiveRecord::Migration[5.1]
  def up
    Post.where.not(head_id: nil).includes(:head).find_each do |post|
      post.head_number = post.head.number
      post.save!
    end
  end

  def down
    Post.where.not(head_id: nil).update_all(head_number: nil)
  end
end
