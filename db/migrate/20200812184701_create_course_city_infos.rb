class CreateCourseCityInfos < ActiveRecord::Migration[6.0]
  def change
    create_table :course_city_infos do |t|
      t.integer :course_id
      t.string :city_name
      t.string :date_info
      t.string :address
      t.boolean :active
      t.integer :position, default: 999
      t.text   :notes
      t.timestamps
    end
    add_index :course_city_infos, :course_id
    add_column :products, :show_city_list, :boolean
  end
end
