class AddUserRefToComment < ActiveRecord::Migration[4.2]
  def change
    add_reference :comments, :user, index: true
  end
end
