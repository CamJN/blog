class RemoveCommenterFromComments < ActiveRecord::Migration[4.2]
  def change
    remove_column :comments, :commenter, :string
  end
end
