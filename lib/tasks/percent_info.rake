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

  task :init_user => :environment do
    %w(
      成都,冷帅,3,15712324266
      成都,胡晓欢,3,18608004504
      重庆,丁海,3,18223862263
      重庆,顾娟娟,3,13708333844
      深圳,吴碧文,3,13828884956
      长沙,黄雅暄(黄生源),3,17775712087
      长沙,胡晓娜,3,13469061004
      包头,魏铭,3,18648250063
      包头,郭治凤,3,13384727616
      无锡,邢秀丽,3,13606197665
      无锡,文华民,3,15161558788
      无锡,金香玉,3,13921291910
      郑州,安紫（杜香桂）,3,13613832276
      郑州,刘娜,3,18637180362
      武汉,马春艳,3,17636189667
      福州,古剑莉,3,13600971203
      福州,周梅玲,3,18567906890
      福州,于景峰,3,13194094331
      运城,王晶玮,3,15234373494
      青岛,张蓓蕾,3,18564287117
      南宁,李卓怡,3,18877199991
      驻马店,姚艳,3,17719158339
      贵阳,吴洁,3,18153117721
      贵阳,刘云,3,15185995588
      贵阳,沈建红,3,18230722344
      濮阳,王路欣,3,18239305691
      长治,王邵华,3,15535579777
      西安,郭洁,3,13909310112
      合肥,李燕,3,18963795709
      云南昆明,沈子新,3,13888220296
      云南昆明,任新艳,3,13759595083
      甘肃兰州,马晶,3,13919826618
      甘肃兰州,刘双佩,3,13619360143
      陕西西安,赵晓芳,3,17392926501
      山东临沂,孙帆,3,15553932121
      山东威海,吕晓玲,3,18963112304
      山东临沂,徐晓桐,3,18653961610
      北京,闻凯歌,3,18801297926
      天津,王佳敏,3,15822325291
      上海,孙玲,3,13641713559
      江西九江,赵文,3,18870215837
      山东青岛,顾玲玲,3,18661761345
      山东青岛,刘芳芳,3,13465116176
      广州,陈喆,3,13926243499
      邯郸,莉姐,4,19801028821
      邯郸,焦雨欣,4,18531003618
      成都,林雪枫,4,13520852735
      重庆,陈瑜（陈小凤）,4,15002310155
      保定,薄蕾,4,13127418688
      深圳,张维,4,13392958149
      长沙,岳艳霞,4,15811006887
      济南,刘薛,4,13910689551
      杭州,何娅楠,4,18032155824
      太原,郭锐,4,13007045893
      沈阳,肖杨,4,13898840123
      大连,王青,4,13898675526
      包头,托娅,4,18604727089
      青岛,孙天超,4,13954229283
      青岛,金银玉,4,13854255556
      无锡,黄守会,4,18351568867
      遵义,田维珊,4,15120283788
      遵义,饶珊珊,4,18385293727
      郑州,刘爱利,4,15538080939
      郑州,朱丽坤,4,13837102269
      武汉,吴清秀,4,15527349217
      厦门,邹禹,4,15080306661
      厦门,孟玲军,4,15959448887
      长春,苏波,4,17743106338
      潍坊,许瑩（许明菊）,4,18265679009
      福州,雷文婷,4,13599445389
      聊城,李海凤,4,13811306025
      运城,张亚楠,4,13703591771
      昆山,龚敬,4,13913279149
      昆山,李霞,4,13916968304
      济宁,于胜男,4,13345196251
      昆明文山,严代娟,4,13308767666
      昆明,尹晓娜,4,13116952129
      菏泽,刘虎,4,18105400010
      南宁,李易,4,13807804229
      驻马店,胡倩倩,4,15103835906
      贵阳,陈雪,4,13809433484
      濮阳,张丹丹,4,15239365888
      长治,常子怡,4,15235515311
      石家庄,史翠翠,4,17733846609
      石家庄,马宁,4,18633064473
      石家庄,周美芳,4,17732168770
      石家庄,马卫荣,4,15931188500
      西安,孙琳,4,13309100531
      合肥,陈云,4,13810295109
    ).each do |line|
      line = line.split(',')
      p line[3]
      user = User.where(phone_number: line[3]).last
      if user.blank?
        user = User.create(phone_number: line[3], name: line[1], status: line[2])
      else
        user.update(status: line[2])
      end
    end
  end
end