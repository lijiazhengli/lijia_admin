namespace :arranger do
  desc '学员导入为整理师'
  task :init => :environment do
    Arranger.destroy_all
    User.where.not(status: 1, name: nil).each do |user|
      item = Arranger.where(name: user.name, phone_number: user.phone_number).first_or_create
      item.update(active: true)
    end
  end


  desc '更新整理师信息'
  task :update_arranger_orders_count => :environment do
    Arranger.where(active: true).each do |item|
      orders_count = OrderArrangerAssignment.where(arranger_id: item.id, order_type: Order::SERVICE_ORDER).select('distinct order_id').count
      item.update_attributes(orders_count: ((item.base_order_count || 0) + orders_count))
    end
  end

  task :init_20201023 => :environment do
    Arranger.update_all(base_order_count: 0, active: false)
    %w(
      古剑莉,厦门,13600971203,36
      雷文婷,福州,13599445389,15
      周梅玲,福州,18567906890,5
      于景峰,厦门,13194094331,5
      江莲妹,福州,15959000406,3
      王丽霞,福州,13799959308,3
      候显菊,福州,13799946242,1
      廖燕梅,福州,13950310672,1
      陈樊钦,福州,13055732510,1
      陈素芳,福州,18686070951,1
      刘敏,菏泽,17605302777,15
      刘虎,菏泽,18105400010,2
      高美霞,菏泽,19506085578,15
      张伟,菏泽,18205406999,6
      张晓蕾,菏泽,15553009285,11
      郭锐,太原,13007045893,60
      韩冰,太原,13994252829,1
      高爱萍,太原,13834579188,5
      房云霞,青岛,18561967199,1
      刘芳芳,青岛,13465116176,30
      张晓宇,青岛,18661951210,5
      孙天超,青岛,13954229283,80
      金银玉,青岛,13854255556,75
      张蓓蕾,青岛,13969752025,1
      顾玲玲,青岛,18661761345,11
      吴琪,青岛,15192045727,9
      房云霞,青岛,18561967199,1
      沈子新,昆明,13888220296,7
      刘素芬,北京,15948535989,200
      张彦净,北京,13426327123,2
      贾苗苗,北京,17160027259,5
      徐凌,昆明,13601386379,7
      闻凯歌,北京,18801297926,19
      苏波,长春,17743106338,10
      赵兴,长春,18604303815,10
      韩利,长春,13804307890,10
      史翠翠,石家庄,17733846609,13
      马卫荣,石家庄,15931188500,3
      刘海霞,石家庄,18833129595,3
      赵茹,石家庄,15033436655,1
      贾美静,石家庄,17717198137,18
      董亮,石家庄,15175780358,0
      马宁,石家庄,18633064473,2
      马晶,兰州,13919826618,3
      刘双佩,兰州,13619360143,3
      张德芳,兰州,15009460870,2
      郗丹丹,沈阳,13940326744,13
      李春娱,盘锦,13904277166,5
      高玲玲,沈阳,15942309059,5
      吴制航,沈阳,18888133710,7
      刘美杨,沈阳,15840007119,19
      周立娟,沈阳,15612377220,12
      王青,大连,13898675526,36
      刘晓晶,大连,15604087002,1
      肖杨,沈阳,13898840123,28
      游静惠,晋中,13834857444,0
      孙玲,上海,13641713559,50
      俞洁,上海,13801775681,1
      王元蕊,上海,13564987903,1
      倪慧蓉,上海,15901788421,5
      黄守会,无锡,18351568867,60
      邢秀丽,无锡,13606197665,2
      金香玉,无锡,13921291910,3
      文华民,无锡,15161558788,4
      吴碧文,深圳,13828884956,64
      王莉,深圳,13662264316,2
      吴琳,深圳,13823281862,10
      张洪义,深圳,13316938088,6
      陈喆,广州,13926243499,5
      徐晓燕,深圳,13148737999,1
      李晓兰,韶关,13798116608,28
      苏蕾,珠海,13673293333,3
      叶颖臻,佛山,13827783422,17
      许文多,深圳,15976828751,8
      屠茁,深圳,18025368772,4
      许铱浜,香港,15986712555,1
      林迎,阳江,18316160037,1
      平虹,顺德,13576682133,1
      陈冰屿,深圳,17880213414,5
      赵辉,佛山,13710880705,0
      吕晓玲,威海,18963112304,0
      刘爱利,郑州,15538080939,70
      杜香桂,郑州,13613832276,60
      李静,郑州,13526661929,56
      尚丹丹,开封,18537899843,56
      张钦瑶,郑州,13674935577,10
      朱志红,郑州,15515824678,30
      薛丽娟,郑州,13503831177,10
      李海霞,郑州,13607683967,40
      刘小琴,洛阳,13525225577,15
      吴艳莉,郑州,13633850961,12
      牛庆庆,郑州,13027786969,6
      王珍,郑州,13837153876,3
      贺彦雨,洛阳,18848975241,6
      胡紫鹃,新乡,13569801092,12
      马建云,郑州,15037108728,6
      皇甫玲玲,郑州,18336369620,1
      王爽,郑州,13676982770,8
      隋微微,郑州,15981969996,0
      任玲,郑州,18703677778,1
      袁静静,郑州,13783605834,0
      郑慧,郑州,13838285362,0
      孙春燕,郑州,18790280558,1
      武天润,郑州,18768885370,0
      柳亚文,郑州,15617716800,0
      连倩倩,郑州,18618118781,0
      代玉玲,郑州,13838559019,0
      李美娴,郑州,18839775923,1
      路玉双,新乡,18738329909,1
      荣利霞,郑州,18638159036,3
      牛洋洋,洛阳,13849957727,0
      张攀星,,13673360757,1
      申红磊,郑州,13613809152,0
      胡晓娜,长沙,13469061004,20
      黄雅喧,长沙,17607319548,7
      陈雪,贵阳,13809433484,41
      刘云,铜仁,15185995588,24
      沈建红,贵阳,18230722344,22
      陈沙沙,铜仁,16685168682,0
      阮光会,铜仁,15808565288,1
      兰菲,贵阳,15870142765,18
      张艺,贵阳,17588810169,5
      刘雪梅,贵阳,13829794349,5
      何龄梅,贵阳,13885162620,12
      井坤,烟台,15725505255,2
      孙琳,咸阳,13309100531,10
      郭洁,兰州,13909310112,7
      薛琼瑶,西安,18884116822,1
      左延卿,咸阳,13992033378,0
      高静,西安,18092288701,1
      锦葵（李珍珍）,西安,15991653322,0
      董庆,西安,13669269149,6
      张丹,西安,18691882586,21
      冯新爱,西安,18729538221,1
      王蓉,西安,17782589756,6
      赵晓芳,西安,17392926501,1
      任倩,西安,13720419019,0
      张晓燕,西安,18991380680,0
      曾娟,西安,13309188608,0
      徐蕾,咸阳,18791946803,8
      刘小琴,洛阳,13525225577,15
      贺彦雨,洛阳,18848975241,6
      牛洋洋,洛阳,13849957727,0
      王小丽,洛阳,13633872288,14
      邹禹,厦门,15080306661,0
      孟玲军,厦门,15959448887,0
      赖燕燕,厦门,13599518893,3
      潘宝瑜,泉州,13686881939,5
      张子明,厦门,15959444502,2
      陈玉宽,泉州,18559819005,6
      张道伟,天津,13642024004,5
      王薇,天津,17320096506,0
      于文萍,天津,13323306909,1
      张艳,天津,13821820095,1
      王虹阳,天津,18526415043,1
      于佳,天津,13194696261,1
      林佳妮,天津,15022630396,0
      冯倩,天津,13821250616,0
      黄宇齐,天津,15900333912,0
      王佳敏,天津,15822325291,12
      黄霞,九江,18707021598,2
      刘玉,九江,18621562543,2
      赵文,九江,18870215837,2
      陈瑜,重庆,15002310155,0
      顾娟娟,重庆,13708333844,0
      丁海,重庆,18223862263,15
      李春花,重庆,15683443777,3
      陈卫,重庆,18223093800,5
      肖龙,重庆,15736009644,2
      吴小磊,重庆,15909376321,1
      张启桢,重庆,17774947216,0
      李洁,重庆,13808355131,3
      吴碧文,深圳,13828884956,64
      王莉,深圳,13662264316,2
      吴琳,深圳,13823281862,10
      张洪义,深圳,13316938088,6
      陈喆,广州,13926243499,5
      徐晓燕,深圳,13148737999,1
      李晓兰,韶关,13798116608,28
      苏蕾,珠海,13673293333,3
      叶颖臻,佛山,13827783422,17
      许文多,深圳,15976828751,8
      屠茁,深圳,18025368772,4
      许铱浜,香港,15986712555,1
      林迎,阳江,18316160037,1
      平虹,顺德,13576682133,1
      陈冰屿,深圳,17880213414,5
      赵辉,佛山,13710880705,0
      陈艳,遵义,18985669616,15
      田维珊,遵义,15120283788,45
      饶珊珊,遵义,18385293727,42
      王倩,遵义,18985268988,7
      李梅,遵义,18685538299,40
      赵丽,驻马店,17739677920,0
      周银燕,驻马店,18939656344,0
      陈聪,驻马店,18339693311,0
      晏成立,驻马店,15565933176,1
      谢会丹,驻马店,17884806243,1
      胡倩倩,驻马店,19903965688,26
      胡那,驻马店,13123714676,7
      姚艳,驻马店,17719158339,22
      李沐暮（李霞）,昆山,13916968304,5
      小灰灰（赵敬慧）,上海,13621637368,1
      俞洁,上海,13801775681,1
      孙云,上海,15216614963,0
      岳岚,上海,13916804663,0
      杨小琴,昆山,13862670712,4
    ).each do |line|
      user_name, address_city, phone_number, base_order_count = line.split(',')
      item = Arranger.where(phone_number: phone_number).first_or_create
      item.update(name: user_name, address_city: address_city, base_order_count: base_order_count, active: true)
    end
  end
end