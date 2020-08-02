namespace :percent_info do 
  desc '初始化提成数据'
  task :init => :environment do
    [
      {item_type: "Base", item_id: 1, status_1: 0, status_2: 20, status_3: 24, status_4: 26, status_5: 28},
      {item_type: "Course", item_id: 66, status_1: 0, status_2: 15, status_3: 19, status_4: 21, status_5: 23}
    ].each do |info|
      item = PercentInfo.where(item_type: info[:item_type], item_id: info[:item_id]).first_or_create
      item.update(info)
    end
  end
end