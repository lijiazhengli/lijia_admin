class Admin::ProductSetImagesController < Admin::BaseController
  before_action :reload_product_set
  layout 'admin'

  def index
    @items = @parent.product_set_images.order('active desc,position')
  end

  def new
    @item = @parent.product_set_images.build
  end

  def create
    @item = @parent.product_set_images.build(sub_image_params)
    if @item.save
      redirect_to admin_product_set_product_set_images_path(@parent)
    else
      render :new
    end
  end

  def update
    @item = @parent.product_set_images.find(params[:id])
    if @item.update_attributes(sub_image_params)
      redirect_to admin_product_set_product_set_images_path(@parent)
    else
      render :edit
    end
  end

  def edit
    @item = @parent.product_set_images.find(params[:id])
  end

  def destroy
    @item = @parent.product_set_images.find(params[:id])
    @item.destroy
    redirect_to admin_product_set_product_set_images_path(@parent), notice: '删除成功'
  end

  def file_upload
    file_upload_to_qiniu('product_set_image')
  end

  def up_serial
    item = ProductSetImage.where(id: params[:id]).first
    if item.up_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def down_serial
    item = ProductSetImage.where(id: params[:id]).first
    if item.down_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def enable
    item = ProductSetImage.find(params[:id])
    if item.enable
      redirect_to admin_product_set_product_set_images_path(@parent), notice: '成功'
    else
      redirect_to admin_product_set_product_set_images_path(@parent), alert: '失败'
    end
  end

  def disable
    item = ProductSetImage.find(params[:id])
    if item.disable
      redirect_to admin_product_set_product_set_images_path(@parent), notice: '成功'
    else
      redirect_to admin_product_set_product_set_images_path(@parent), alert: '失败'
    end
  end

  private

  def reload_product_set
    @parent = ProductSet.find(params[:product_set_id])
  end

  def sub_image_params
    params.require(:product_set_image).permit!
  end
end
