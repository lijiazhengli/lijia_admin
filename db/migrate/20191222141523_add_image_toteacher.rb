class AddImageToteacher < ActiveRecord::Migration[6.0]
  def change
  	add_column :teachers, :mobile_image, :string
  	add_column :teachers, :tag, :string
  	add_column :teachers, :position, :integer
  	add_column :introduces, :tag, :string
  end
end
