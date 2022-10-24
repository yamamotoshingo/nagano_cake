class OrderItem < ApplicationRecord
  belongs_to :item
  belongs_to :order

  enum production_status: { production_not_allowed: 0, waiting_for_production: 1, under_production: 2, production_completed: 3 }

  validates :item_id, presence: true

  def subtotal
    price_including_tax * number
  end
end
