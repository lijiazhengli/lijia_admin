class Export::Accounting
  extend Admin::BaseHelper
  class << self
    def list(orders)
      product_ids = PurchasedItem.where(order_id: orders.map(&:id).uniq).pluck(:product_id)
      product_hash = Product.get_product_list_hash(product_ids)
      users = User.where(id: orders.map(&:user_id))
      phone_numbers =  orders.map(&:referral_phone_number) + orders.map(&:organizer_phone_number)
      phone_numbers_infos = User.where(phone_number: phone_numbers).map{|i| [i.phone_number, i]}.to_h
      total_amount_hash = OrderPaymentRecord.where("timestamp is not null").group(:order_id).sum(:cost)
      tabel_header = %w(单号 城市 状态 折扣 付款信息 产品信息 总金额 订购人姓名 订购人电话 订购人类型 推荐人 组织人 创建时间	修改时间)
      xls_report = StringIO.new
      Spreadsheet.client_encoding = "UTF-8"
      book = Spreadsheet::Workbook.new
      sheet1 = book.create_worksheet :name => "统计"
      style = Spreadsheet::Format.new :weight => :bold, :size => 14, :color=>"black", :border => :thin, :border_color => "black", :pattern => 1, :pattern_fg_color => "white"
      style_right = Spreadsheet::Format.new :align => :right
      style_center = Spreadsheet::Format.new :align => :center
      sheet1.row(0).height = 18
      tabel_header.each_with_index do |item, index|
        if index != 0
          sheet1.column(index).width = 20
        else
          sheet1.column(index).width = 15
        end
      end
      sheet1.row(0).default_format = style
      sheet1.row(0).concat tabel_header

      count_row = 0

      orders.each do |item|
        payed_info = ''
        product_info = ''
        user = users.select{|u| u.id == item.user_id}.first
        referral_info = show_referral_info(item, phone_numbers_infos)
        organizer_info = show_organizer_info(item, phone_numbers_infos)
        item.order_payment_records.each_with_index do |sub_item, index|
          payed_info += '|' if index != 0
          payed_info += sub_item.payment_name.to_s + ','
          payed_info += sub_item.cost.to_s + ','
          payed_info += "交易号: #{sub_item.transaction_id}" if sub_item.transaction_id.present?
        end
        item.purchased_items.each do |sub_item|
          product = product_hash[sub_item.product_id]
          if item.is_product?
            product_info += "#{product[:title]}x#{sub_item.quantity}"
          else
            product_info += product[:title].to_s
          end
        end
        total_amount = total_amount_hash[item.id].to_f.round(2)
        count_row += 1
        result = []
        result << item.external_id
        result << item.city_name || item.address_city
        result << Order::STATUS[item.status]
        result << item.zhekou
        result << payed_info
        result << product_info
        result << total_amount
        result << user.name
        result << user.phone_number
        result << user.show_status
        result << referral_info
        result << organizer_info
        result << item.created_at.strftime('%F %T')
        result << item.updated_at.strftime('%F %T')
        result.each_with_index do |info,index|
          sheet1[count_row,index] = info
        end
      end
      book.write xls_report
      xls_report.string
    end

    def show_referral_info(item, info)
      arr = []
      arr << item.referral_name if item.referral_name.present?
      if item.referral_phone_number.present?
        arr << item.referral_phone_number
        user = info[item.referral_phone_number]
        arr << user.show_status if user.present?
      end
      arr.join('|')
    end

    def show_organizer_info(item, info)
      arr = []
      arr << item.organizer_name if item.organizer_name.present?
      if item.organizer_phone_number.present?
        arr << item.organizer_phone_number
        user = info[item.organizer_phone_number]
        arr << user.show_status if user.present?
      end
      arr.join('|')
    end
  end
end