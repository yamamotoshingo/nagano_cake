class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!
  def index
    @cart_items = current_customer.cart_items
  end

  def create
    @cart_item = CartItem.new(cart_item_params)
    @cart_item.customer_id = current_customer.id
    if CartItem.find_by(item_id: @cart_item.item_id)
      @cart_item = CartItem.find_by(item_id: @cart_item.item_id)
      @cart_item.update(amount: @cart_item.amount + cart_item_params[:amount].to_i)
      redirect_to cart_items_path
    else
      if @cart_item.save
        redirect_to cart_items_path
      else
        @item = @cart_item.item
        render 'public/items/show'
      end
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update(cart_item_params)
    redirect_to cart_items_path
  end

  def destroy_all
    current_customer.cart_items.destroy_all
    redirect_to cart_items_path
  end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.delete
    redirect_to cart_items_path
  end

  private
  def cart_item_params
      params.require(:cart_item).permit(:item_id, :amount)
  end
end
