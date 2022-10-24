class Order < ApplicationRecord
  has_many :order_items, dependent: :destroy
  belongs_to :customer, optional: true

  enum payment_method: { credit_card: 0, transfer: 1 }
  enum order_status: { waiting_for_payment: 0, payment_confirmation: 1, production: 2, shipping_preparation: 3, sent: 4}

  validates :postal_code, presence: true
  validates :address, presence: true
  validates :name, presence: true

  def total_price
    total = 0
    customer.cart_items.each do |cart_item|
      total += cart_item.subtotal
    end
  end
end
