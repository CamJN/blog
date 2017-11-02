class AddRoleRefToUser < ActiveRecord::Migration[4.2]
  def change
    add_reference :users, :role, index: true
  end
end
