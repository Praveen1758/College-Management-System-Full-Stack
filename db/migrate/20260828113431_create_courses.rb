class CreateCourses < ActiveRecord::Migration[8.1]
  def change
    create_table :courses do |t|
      t.string :name, null: false
      t.text :description

      t.timestamps
    end
    add_index :courses, :name, unique: true
  end
end
