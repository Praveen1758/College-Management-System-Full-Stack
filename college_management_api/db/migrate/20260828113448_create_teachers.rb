class CreateTeachers < ActiveRecord::Migration[8.1]
  def change
    create_table :teachers do |t|
      t.string :name, null: false
      t.string :email, null: false

      t.timestamps
    end
    add_index :teachers, :email, unique: true
  end
end
