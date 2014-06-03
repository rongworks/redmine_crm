class AddPhoneMobileToClients < ActiveRecord::Migration
  def change
    add_column :clients, :phone_mobile, :string
  end
end