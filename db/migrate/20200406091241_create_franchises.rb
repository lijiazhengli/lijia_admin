class CreateFranchises < ActiveRecord::Migration[6.0]
  def change
    create_table :franchises do |t|
      t.integer  :user_id
      t.string   :title
      t.string   :user_name
      t.string   :phone_number
      t.string   :email
      t.string   :front_image
      t.string   :detailed_image
      t.string   :status, default: 'unconfirmed'
      t.string   :city_name
      t.text     :desc
      t.boolean  :active
      t.integer  :position
      t.string   :applet_form_id
      t.timestamps
    end
  end
end
