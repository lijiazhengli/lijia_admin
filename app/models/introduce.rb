class Introduce < ApplicationRecord
  ITEM_TYPE = {'applet_home' => '小程序品牌介绍', 'applet_team' => '小程序团队介绍'}
  scope :applet_home, -> {where(item_type: "applet_home", active: true)}
  scope :applet_team, -> {where(item_type: "applet_team", active: true)}  

  def to_applet_list
    {
      title: self.title,
      tag: self.tag,
      img_url: self.mobile_image,
      desc: self.description
    }
  end
end
