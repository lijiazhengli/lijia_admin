# required
# WxPay.appid = ENV['WX_APP_ID']
WxPay.key = ENV['WX_MCH_KEY']
WxPay.mch_id = ENV['WX_MCH_ID']

# cert, see https://pay.weixin.qq.com/wiki/doc/api/app.php?chapter=4_3
# using PCKS12
# WxPay.set_apiclient_by_pkcs12(File.binread("#{ENV['WX_PKCS12_FILEPATH']}"), ENV['WX_API_KEY'])
WxPay.set_apiclient_by_pkcs12(File.binread("#{ENV['WX_PKCS12_FILEPATH']}"), ENV['WX_MCH_ID'])

# optional - configurations for RestClient timeout, etc.
WxPay.extra_rest_client_options = {timeout: 5, open_timeout: 8}