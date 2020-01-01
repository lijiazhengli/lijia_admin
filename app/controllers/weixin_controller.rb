class WeixinController < ApplicationController
  #skip_before_action :verify_authenticity_token, only: [:index, :show, :create]
  protect_from_forgery
  #before_action :authenticate, only: [:index, :show, :create]
  #before_action :read_and_authenticate_payment, only: [:verify]
  layout false

  # 微信公众平台入口验证，GET
  def index
    render text: params[:echostr]
  end

  # 微信公众平台入口验证，GET
  def show
    render text: params[:echostr]
  end

  # 微信公众平台请求入口，POST
  # 根据参数分发Request
  def create
    xml = request.body.read
    parser = Wx::Parser.new(xml)
    wx_request = parser.get_request
    # 事件消息
    logger.info "=========wenxin wx_request MsgType: #{wx_request.to_json}================"
    if wx_request.is_event 
      # view事件
      if wx_request.is_event_view        
        redirect_to "#{wx_request.EventKey}"
      else
        render :xml => parser.parse
        if wx_request.EventKey == 'recommend_users'
          Wx::Api.get_customer_qrcode_url(wx_request.FromUserName)
          QrScanResult.find_or_create_by(code: wx_request.FromUserName, wx_open_id: wx_request.FromUserName, event: 'recommend_users')
        end rescue nil
        if wx_request.Event == 'subscribe'
          key = wx_request.EventKey
          if key.present? && key =~ /qrscene_/
            scene = $'
            if scene.to_s.length >= 28
              user_name = Wx::Api.get_nickname_by(wx_request.FromUserName)
              Wx::Api.custom_send({"touser" => wx_request.FromUserName, "msgtype" => "text", "text" => { "content" => "亲爱的@#{user_name}, 恭喜你获得品尝派悦坊玛德琳蛋糕的机会！\n\n活动说明：\n1.分享专属海报，成功邀请5位新朋友，即有机会获得玛德琳尝鲜礼盒（满足起送价即可随单配送） \n2.玛德琳尝鲜礼盒限量99份，先到先得，送完即止\n\n赶快向身边的吃货们，发起美味邀请吧(‵▽′)/" }}, true)
              Wx::Api.get_customer_qrcode_url(wx_request.FromUserName)
            end
          end
        end rescue nil
        if wx_request.Event == 'SCAN'
          scene = wx_request.EventKey
          if scene.present? && scene.to_s.length >= 28
            user_name = Wx::Api.get_nickname_by(wx_request.FromUserName)
            Wx::Api.get_customer_qrcode_url(wx_request.FromUserName)
          end
        end rescue nil
      end
    # 普通消息
    elsif wx_request.is_text?
      logger.info "=========wenxin request text render_xml: #{render_xml}================"
      if render_xml
        render :xml => render_xml
      else
        render :text => "", :status => "200"
      end
      if wx_request.Content == 'IT测试功能8a15cf7fff03c2f08a3b883a714ffdf4'
        Wx::Api.get_customer_qrcode_url(wx_request.FromUserName)
      end rescue nil
    else
      WeixinMessage.create_message(wx_request)
      render :text => "", :status => "200"
    end
  end


  # 微信支付验证回调方法
  def wx_verify
    logger.info "========= wenxin_pay_verify_params: #{params.inspect}================"
    result = Hash.from_xml(request.body.read)["xml"]
    if WxPay::Sign.verify?(result)
      transfer_fee = (result["total_fee"].to_f)/100
      option = {out_trade_no: result["out_trade_no"], transfer_received: transfer_fee, transaction_id: result["transaction_id"]}
      logger.info "=========wenxin_pay_verify_params_option option: #{option.inspect} openid: #{result["openid"]}================"
      order = Order.update_order_transfer_info(option)
      if order
        render :xml => {return_code: "SUCCESS"}.to_xml(root: 'xml', dasherize: false)
      else
        render :xml => {return_code: "ERROR"}.to_xml(root: 'xml', dasherize: false)
      end
    end
  end

  # 微信支付测试入口
  def test_request
    render json: Weixin.generate_test_payment_json
  end

  def test
    render 'test', layout: 'application'
  end


  protected

  # 微信公众平台接入验证
  def authenticate
   signature = [Weixin::TOKEN, params[:timestamp], params[:nonce]].compact.sort.join

   if params[:signature] != Digest::SHA1::hexdigest(signature)
     render text: 'Forbidden', status: 403
   end
  end


end
