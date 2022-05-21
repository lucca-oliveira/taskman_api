class CreateCategories < ActiveRecord::Migration[6.0]
  def change
    create_table :categories do |t|
      # General information
      t.string  :name
      t.boolean :default_category, default: false
      t.integer :position

      # Relations
      t.belongs_to :project

      t.timestamps
    end
  end
end
