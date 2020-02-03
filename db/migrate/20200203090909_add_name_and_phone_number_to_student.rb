class AddNameAndPhoneNumberToStudent < ActiveRecord::Migration[6.0]
  def change
    add_column :students, :phone_number, :string, limit: 20
    add_column :students, :name, :string
  end
end
