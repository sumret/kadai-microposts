class AddPrivilegeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :privilege, :string
  end
end
