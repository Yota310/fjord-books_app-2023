class AddAddressPostcodeToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :address, :string
    add_column :users, :postcode, :integer
  end
end
