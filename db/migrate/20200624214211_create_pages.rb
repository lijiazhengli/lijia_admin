class CreatePages < ActiveRecord::Migration[6.0]
  def change
    create_table :pages do |t|
      t.string   :url, limit: 50
      t.string   :title
      t.text     :content
      t.boolean  :active
      t.timestamps
    end

    add_index :pages, :url

    add_column :products, :sub_title, :string
  end
end
