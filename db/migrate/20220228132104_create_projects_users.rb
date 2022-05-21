class CreateProjectsUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :projects_users do |t|
      # General information
      t.integer :role, default: 0

      # Relations
      t.belongs_to :user
      t.belongs_to :project

      t.timestamps
    end
  end
end
