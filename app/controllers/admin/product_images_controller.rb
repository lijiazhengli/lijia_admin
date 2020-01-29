class Admin::ProductImagesController < Admin::BaseController
  before_action :reload_product
  layout 'admin'

  def index
    @items = @product.product_images.order('active desc,position')
  end

  def new
    @item = @product.product_images.build
  end

  def create
    @item = @product.product_images.build(product_image_params)
    if @item.save
      redirect_to admin_product_product_images_path(@product)
    else
      render :new
    end
  end

  def update
    @item = @product.product_set_images.find(params[:id])
    if @item.update_attributes(product_image_params)
      redirect_to admin_product_product_images_path(@product)
    else
      render :edit
    end
  end

  def edit
    @item = @product.product_images.find(params[:id])
  end

  def destroy
    @item = @product.product_images.find(params[:id])
    @item.destroy
    redirect_to :back
  end

  def file_upload
    file_upload_to_qiniu('product_image')
  end

  def up_serial
    item = ProductImage.where(id: params[:id]).first
    if item.up_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def down_serial
    item = ProductImage.where(id: params[:id]).first
    if item.down_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def enable
    item = ProductImage.find(params[:id])
    if item.enable
      redirect_to admin_product_product_images_path(@product), alert: '成功'
    else
      redirect_to admin_product_product_images_path(@product), alert: '失败'
    end
  end

  def disable
    item = ProductImage.find(params[:id])
    if item.disable
      redirect_to admin_product_product_images_path(@product), alert: '成功'
    else
      redirect_to admin_product_product_images_path(@product), alert: '失败'
    end
  end

  private

  def reload_product
    @product = Product.find(params[:product_id])
  end

  def product_image_params
    params.require(:product_image).permit!
  end
end
