class Product < ActiveRecord::Base
  scope :active, -> { where(active: true) }

  def to_applet_show
    {
      id: self.id,
      title: self.title,
      desc: self.description,
      price: self.price,
      city_name: self.city_name,
      start_date: self.start_date,
      end_date: self.end_date,
      img_url: self.detailed_image
    }
  end

  def to_applet_list
    {
      id: self.id,
      title: self.title,
      price: self.price,
      img_url: self.front_image
    }
  end

  def self.get_product_list_hash(product_ids)
    products =  Product.where(id: product_ids)
    item_hash = {}
    products.each do |product|
      item_hash[product.id] = product.to_applet_list
    end
    return item_hash
  end
end