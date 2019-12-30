class AddAppletFormIdToOrder < ActiveRecord::Migration[6.0]
  def change
  	add_column :orders, :applet_form_id, :string
  end
end
