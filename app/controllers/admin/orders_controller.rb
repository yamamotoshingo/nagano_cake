class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin!
  def show
    @order = Order.find(params[:id])
  end

  def update
    @order = Order.find(params[:id])
    @order.update(order_params)
    if @order.order_status_before_type_cast == 1
      @order.order_items.update_all(production_status: 1)
    elsif @order.order_status_before_type_cast == 0
      @order.order_items.update_all(production_status: 0)
    end
    redirect_to admin_order_path(@order.id)
  end

  private

  def order_params
    params.require(:order).permit(:order_status)
  end

end
