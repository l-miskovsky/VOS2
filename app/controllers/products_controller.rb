class ProductsController < ApplicationController
  def new
    @product = Product.new
  end

  def index
    @products = Product.paginate(page: params[:page], :per_page => 25).order('name ASC')
    @shoplist = Shoplist.find(params[:shoplist_id])
    self.new
  end

  def ins
    #@shoplist = current_user.shoplists.first #
    @shoplist = current_user.shoplists.find(params[:shoplist_id])
    @product = Product.find(params[:id])
    @shoplist.item_in_lists.create(product: @product)

    redirect_to shoplist_products_path
  end

  def show
    @product = Product.find(params[:id])
    @prices = @product.prices.paginate(page: params[:page])
    #shoplist_add_product @product
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path
    else
      render 'new'
    end
  end

  def destroy
  end

  private
  def product_params
    params.require(:product).permit(:name, :price)
  end
end
