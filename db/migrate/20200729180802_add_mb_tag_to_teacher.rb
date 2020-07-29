class AddMbTagToTeacher < ActiveRecord::Migration[6.0]
  def change
  	add_column :teachers, :web_tag, :string
  end
end
