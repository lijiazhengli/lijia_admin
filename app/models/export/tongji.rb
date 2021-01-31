class Export::Tongji
  extend Admin::BaseHelper
  class << self
    def city(orders)
      users_hash = User.where(id: orders.map(&:user_id)).pluck(:id, :phone_number).to_h
      product_ids = PurchasedItem.where(order_id: orders.map(&:id).uniq).pluck(:product_id)
      product_hash = Product.get_product_list_hash(product_ids)
      referral_infos = User.where(phone_number: orders.map(&:referral_phone_number)).map{|i| [i.phone_number, i]}.to_h
      order_payment_records = OrderPaymentRecord.where(order_id: orders.map(&:id))
      tabel_header = %w(单号 订购人 收货人 产品信息 省 市 区 地址 小区 推荐人 组织人 定金 尾款 费用合计 状态 创建时间)
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
          sheet1.column(index).width = 50
        else
          sheet1.column(index).width = 15
        end
      end
      sheet1.row(0).default_format = style
      sheet1.row(0).concat tabel_header

      count_row = 0

      orders.each do |item|
        count_row += 1
        result = []
        result << item.external_id
        result << users_hash[item.user_id]
        result << "#{item.recipient_name}|#{item.recipient_phone_number}"
        p_info_arr = []
        item.purchased_items.each do |sub_item|
          product = product_hash[sub_item.product_id]
          if product
            if item.order_type == Order::PRODUCT_ORDER
              p_info_arr << "#{product[:title]}x#{sub_item.quantity}"
            else
              p_info_arr << product[:title]
            end
          end
        end
        result << p_info_arr.join("\r\n")
        result << item.address_province
        result << item.address_city
        result << item.address_district
        result << item.location_title
        result << item.location_details
        result << show_referral_info(item, {})

        result << show_organizer_info(item, {})
        result << order_payment_records.select{|r| r.order_id == item.id and r.payment_method_id == Order::TENPAY_ID}.map(&:cost).map(&:to_f).reduce(0, :+).round(2)

        result << order_payment_records.select{|r| r.order_id == item.id and r.payment_method_id != Order::TENPAY_ID}.map(&:cost).map(&:to_f).reduce(0, :+).round(2)
        result << order_payment_records.select{|r| r.order_id == item.id}.map(&:cost).map(&:to_f).reduce(0, :+).round(2)
        result << Order::STATUS[item.status]
        result << item.created_at.strftime('%F %T')
        result.each_with_index do |info,index|
          sheet1[count_row,index] = info
        end
      end
      book.write xls_report
      xls_report.string
    end

    def achievement(per_infos, infos, users)
      tabel_header = %w(姓名 电话 类型 整理服务金额(业绩) 课程金额(业绩) 收纳工具金额(业绩) 业绩总计 整理服务金额(提成) 课程金额(提成) 收纳工具金额(提成) 提成总计)
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
          sheet1.column(index).width = 50
        else
          sheet1.column(index).width = 15
        end
      end
      sheet1.row(0).default_format = style
      sheet1.row(0).concat tabel_header

      count_row = 0
      infos.each do |phone_number, item|
        count_row += 1
        result = []
        user = users.select{|i| i.phone_number == phone_number}.first
        result << user.try(:name)
        result << User::STATUS[user.try(:status) || 1]
        result << phone_number

        yeji_count = 0
        ["service", 'course', 'product'].each do |pre|
          item_name = (pre + '_yeji_order_ids').to_sym
          if item[item_name].present?
            sum = OrderPaymentRecord.tongji.where(order_id: item[item_name]).sum(:cost).round(2)
            yeji_count += sum
            result << sum
          else
            result << 0
          end
        end
        result << yeji_count

        ticheng_count = 0
        ["service", 'course', 'product'].each do |pre|
          item_name = (pre + '_ticheng_order_ids').to_sym
          if item[item_name].present?
            order_ids = item[item_name].dup
            sum = 0
            per_infos.each do |info|
              cur_order_ids = info.item_type != 'Base' ? [info.item_id] : order_ids
              sum = (OrderPaymentRecord.tongji.where(order_id: cur_order_ids).sum(:cost) * info.send("status_#{user.try(:status) || 1}"))
              order_ids -= cur_order_ids
              sum = (sum/100).round(2)
              ticheng_count += sum
              result << sum
            end
          else
            result << 0
          end
        end
        result << ticheng_count
        result.each_with_index do |info,index|
          sheet1[count_row,index] = info
        end
      end
      book.write xls_report
      xls_report.string
    end
  end
end