class ChangeColumnNullInCommentsAndUsers < ActiveRecord::Migration[4.2]
  def change
    change_column_null :comments, :user_id, false, 1
    change_column_null :users, :role_id, false, 1
  end
end
