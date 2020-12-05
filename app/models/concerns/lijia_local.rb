module LijiaLocal
  extend ActiveSupport::Concern
  def change_to_qiniu_https_url url
    if url.include?(ENV['QINIU_URL']) and ENV['QINIU_URL_HTTPS'].present?
      url = url.gsub(ENV['QINIU_URL'], ENV['QINIU_URL_HTTPS'])
    end
    return url
  end
end