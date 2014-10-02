class AddRecommendationToCompany < ActiveRecord::Migration
  def change
    add_column :companies, :recommendation, :string
  end
end