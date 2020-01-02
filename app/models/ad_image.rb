class AdImage < ApplicationRecord
  #AD_TYPE = {'applet_home' => '小程序首页', 'applet_service' => '小程序莉家服务页面', 'applet_course' => '小程序课程页面', 'applet_good' => '收纳工具'}
  AD_TYPE = {'applet_home' => '小程序首页', 'applet_service' => '小程序莉家服务页面', 'applet_good' => '收纳工具页面'}
  scope :applet_home, -> {where(ad_type: "applet_home", active: true)}
  scope :applet_service, -> {where(ad_type: "applet_service", active: true)}
  scope :applet_course, -> {where(ad_type: "applet_course", active: true)}
  scope :applet_good, -> {where(ad_type: "applet_good", active: true)}

  def to_applet_list
    {
      title: self.title,
      url: self.url,
      img_url: self.mobile_image
    }
  end
end
