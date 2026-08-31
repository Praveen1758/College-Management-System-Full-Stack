class CreateStudents < ActiveRecord::Migration[8.1]
  def change
    create_table :students do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.integer :age
      t.integer :marks
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
    add_index :students, :email, unique: true
  end
end
