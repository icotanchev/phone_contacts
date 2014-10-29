class CreateFileOperations < ActiveRecord::Migration
  def change
    create_table :file_operations do |t|
      t.string :file_path
      t.string :status
      t.string :job_class
      t.string :user_type
      t.integer :user_id
      t.text :info

      t.timestamps
    end
  end
end
