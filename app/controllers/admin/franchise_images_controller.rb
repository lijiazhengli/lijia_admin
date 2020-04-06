class Admin::FranchiseImagesController < Admin::BaseController
  before_action :reload_item_parent
  layout 'admin'

  def index
    @items = @parent.franchise_images.order('active desc,position')
  end

  def new
    @item = @parent.franchise_images.build
  end

  def create
    @item = @parent.franchise_images.build(sub_image_params)
    if @item.save
      redirect_to admin_franchise_franchise_images_path(@parent)
    else
      render :new
    end
  end

  def update
    @item = @parent.franchise_images.find(params[:id])
    if @item.update_attributes(sub_image_params)
      redirect_to admin_franchise_franchise_images_path(@parent)
    else
      render :edit
    end
  end

  def edit
    @item = @parent.franchise_images.find(params[:id])
  end

  def destroy
    @item = @parent.franchise_images.find(params[:id])
    @item.destroy
    redirect_to :back
  end

  def file_upload
    file_upload_to_qiniu('product_image')
  end

  def up_serial
    item = FranchiseImage.where(id: params[:id]).first
    if item.up_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def down_serial
    item = FranchiseImage.where(id: params[:id]).first
    if item.down_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def enable
    item = FranchiseImage.find(params[:id])
    if item.enable
      redirect_to admin_franchise_franchise_images_path(@parent), alert: '成功'
    else
      redirect_to admin_franchise_franchise_images_path(@parent), alert: '失败'
    end
  end

  def disable
    item = FranchiseImage.find(params[:id])
    if item.disable
      redirect_to admin_franchise_franchise_images_path(@parent), alert: '成功'
    else
      redirect_to admin_franchise_franchise_images_path(@parent), alert: '失败'
    end
  end

  private

  def reload_item_parent
    @parent = Franchise.find(params[:franchise_id])
  end

  def sub_image_params
    params.require(:franchise_image).permit!
  end
end
