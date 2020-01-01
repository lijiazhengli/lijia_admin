require "open-uri"
module Wx
  class MiniApplet
    APP_ID = ENV['WX_MINIAPPLET_APP_ID']
    APP_SECRET = ENV['WX_MINIAPPLET_APP_SECRET']

    # Post微信菜单到微信服务器
    def self.get_open_id_by(code)
      url = 'https://api.weixin.qq.com/sns/jscode2session'
      option = {appid: APP_ID, secret: APP_SECRET, js_code: code, grant_type: 'authorization_code'}
      request = JSON.parse(RestClient.get url, {params: option}) rescue {}
    end


    def self.decryptData(session_key, option)
      Rails.logger.info "----#{Time.now.strftime("%F %T")}-----session_key: #{session_key}"
      Rails.logger.info "----#{Time.now.strftime("%F %T")}-----option: #{option.inspect}"
      session_key = session_key
      encryptedData = option[:encryptedData]
      iv = option[:iv]
      return nil if encryptedData.blank? or iv.blank?
      session_key = Base64.decode64(session_key)
      encrypted_data = Base64.decode64(encryptedData)
      iv = Base64.decode64(iv)

      cipher = OpenSSL::Cipher::AES.new(128, :CBC)
      cipher.decrypt
      cipher.padding = 0
      cipher.key = session_key
      cipher.iv  = iv

      decrypted_plain_text = cipher.update(encrypted_data) + cipher.final
      Rails.logger.info "----#{Time.now.strftime("%F %T")}-----decrypted_plain_text: #{decrypted_plain_text}"
      decrypted_plain_text = decrypted_plain_text.strip.gsub(/[\u0000-\u001F\u2028\u2029]/, '')
      p decrypted_plain_text
      result = JSON.parse(decrypted_plain_text)
      p result
      return nil if result['watermark']['appid'] != APP_ID
      result['purePhoneNumber']
    end

  end
end






