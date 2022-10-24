class Admin::OrderItemsController < ApplicationController
  before_action :authenticate_admin!
  def update
    @order_item = OrderItem.find(params[:id])
    @order_item.update(order_item_params)
    if @order_item.production_status_before_type_cast == 2
      @order_item.order.update(order_status: 2)
    end
    if @order_item.order.order_items.pluck(:production_status).all? { |w| OrderItem.production_statuses[w.to_sym] == 3 }
      @order_item.order.update(order_status: 3)
    end
    redirect_to admin_order_path(@order_item.order_id)
  end

  private

  def order_item_params
    params.require(:order_item).permit(:production_status)
  end
end
