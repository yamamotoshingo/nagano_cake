class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!
  def new
    @order = Order.new
  end

  def confirm
    @cart_items = current_customer.cart_items
    @order = Order.new(order_params)
    if params[:order][:select_address] == "0"
      @order.postal_code = current_customer.postal_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name + current_customer.first_name
    elsif params[:order][:select_address] == "1"
      if params[:order][:address_id] == ""
        redirect_to new_order_path
      else
      @address = Address.find(params[:order][:address_id])
      @order.postal_code = @address.postal_code
      @order.address = @address.address
      @order.name = @address.name
      end
    else
    if @order.invalid?
      render :new
    end
    end
  end

  def create
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @order.shipping_fee = 800
    @order.billing_amount = current_customer.total_price + 800
    @order.save
    current_customer.cart_items.each do |cart_item|
    @order_item = OrderItem.new
    @order_item.order_id = @order.id
    @order_item.item_id = cart_item.item_id
    @order_item.number = cart_item.amount
    @order_item.price_including_tax = cart_item.item.add_tax_price
    @order_item.save
    end
    current_customer.cart_items.destroy_all
    redirect_to completion_orders_path
  end

  def completion
  end

  def index
    @orders = current_customer.orders
  end

  def show
    @order = Order.find(params[:id])
  end

  private
  def order_params
    params.require(:order).permit(:payment_method, :postal_code, :address, :name)
  end
end
