class Public::ItemsController < ApplicationController
  def index
    @genres = Genre.all
    if params[:search] ==  nil || ''
      @items = Item.page(params[:page]).per(8)
    else
      @items = Item.where("name LIKE ? ",'%' + params[:search] + '%').page(params[:page]).per(8)
    end
    if params[:id]
    @items = Item.where(genre_id: params[:id].to_i).page(params[:page]).per(8)
    end
  end

  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem.new
  end
end
