class AddUserIdToContacts < ActiveRecord::Migration
  def change
  	change_table(:contacts) do |t|
      t.integer :user_id, null: false
    end
  end
end
