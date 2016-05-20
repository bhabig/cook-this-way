class AddUserAndCategoryToRecipes < ActiveRecord::Migration
  def change
    add_column :recipes, :user_id, :integer
    add_column :recipes, :category_id, :integer
  end
end
