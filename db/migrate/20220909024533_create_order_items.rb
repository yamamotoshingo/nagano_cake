class CreateOrderItems < ActiveRecord::Migration[6.1]
  def change
    create_table :order_items do |t|
      t.integer :order_id
      t.integer :item_id
      t.integer :number
      t.integer :price_including_tax
      t.integer :production_status, default: 0

      t.timestamps
    end
  end
end
