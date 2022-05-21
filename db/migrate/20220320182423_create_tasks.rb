class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :name
      t.text :description
      t.date :start_date
      t.date :due_date
      t.integer :status, default: 0
      t.timestamps

      t.belongs_to :category
      t.belongs_to :user, optional: true
    end
  end
end
