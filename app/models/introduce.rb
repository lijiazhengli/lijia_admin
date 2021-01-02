class Introduce < ApplicationRecord
  audited
  include LijiaLocal

  ITEM_TYPE = {
    'applet_home' => '小程序品牌介绍', 'applet_team' => '团队介绍', 'applet_franchise' => '加盟服务介绍',
    'web_home' => '官网首页', 'home_info' => "品牌介绍", 'franchise' => '加盟服务'
  }
  scope :applet_home, -> {where(item_type: "applet_home", active: true).order(:position)}
  scope :active_team, -> {where(item_type: "applet_team", active: true).order(:position)}
  scope :applet_franchise, -> {where(item_type: "applet_franchise", active: true).order(:position)}
  scope :web_home, -> {where(item_type: "web_home", active: true)}
  scope :active, -> {where(active: true)}
  scope :web_info, -> {where(active: true, item_type: ["home_info", 'franchise']).order(:position)}
  scope :web_list, -> {where(active: true, item_type: ["web_list"]).order(:position)} 

  def to_web_list
    {
      title: self.title,
      tag: self.tag,
      pc_img_url: change_to_qiniu_https_url(self.pc_image),
      mb_img_url: change_to_qiniu_https_url(self.mobile_image),
      desc: self.description
    }
  end

  def to_applet_list
    {
      title: self.title,
      tag: self.tag,
      img_url: change_to_qiniu_https_url(self.mobile_image),
      desc: self.description
    }
  end
end
