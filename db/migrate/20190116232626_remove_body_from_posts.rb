class RemoveBodyFromPosts < ActiveRecord::Migration[5.2]
  def change
    remove_column :posts, :body, :text
  end
end
