module ApplicationHelper
  def change_to_qiniu_https_url url
    if url.include?(ENV['QINIU_URL']) and ENV['QINIU_URL_HTTPS'].present?
      url = url.gsub(ENV['QINIU_URL'], ENV['QINIU_URL_HTTPS'])
    elsif url.present? and !url.include?('http')
      url = ENV['QINIU_URL_HTTPS'] + url
    end
    return url
  end
end
