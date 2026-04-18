# This migration comes from spree_delhivery (originally 20251228081459)
class AddDelhiveryToReturnAuthorizations < ActiveRecord::Migration[7.0]
  def change
    # FIX: Use 'spree_return_authorizations', not 'return_authorizations'
    unless column_exists?(:spree_return_authorizations, :delhivery_waybill)
      add_column :spree_return_authorizations, :delhivery_waybill, :string
    end

    unless column_exists?(:spree_return_authorizations, :delhivery_ref_id)
      add_column :spree_return_authorizations, :delhivery_ref_id, :string
    end

    unless column_exists?(:spree_return_authorizations, :delhivery_label_url)
      add_column :spree_return_authorizations, :delhivery_label_url, :string
    end
  end
end