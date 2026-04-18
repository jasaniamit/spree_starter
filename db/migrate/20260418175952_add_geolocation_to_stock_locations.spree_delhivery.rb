# This migration comes from spree_delhivery (originally 20251227112401)
class AddGeolocationToStockLocations < ActiveRecord::Migration[7.1]
  def change
    unless column_exists?(:spree_stock_locations, :latitude)
      add_column :spree_stock_locations, :latitude, :decimal, precision: 10, scale: 6
    end

    unless column_exists?(:spree_stock_locations, :longitude)
      add_column :spree_stock_locations, :longitude, :decimal, precision: 10, scale: 6
    end
    
    # Optional: Add an index if you plan to search by location (e.g., "nearest store")
    unless index_exists?(:spree_stock_locations, [:latitude, :longitude])
      add_index :spree_stock_locations, [:latitude, :longitude]
    end
  end
end