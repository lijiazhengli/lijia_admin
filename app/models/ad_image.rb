class AdImage < ApplicationRecord
  AD_TYPE = {'applet_home' => '小程序首页'}
  scope :applet_home, -> {where(ad_type: "applet_home", active: true)}

  def to_applet_list
    {
      title: self.title,
      url: self.url,
      img_url: self.mobile_image
    }
  end
end
