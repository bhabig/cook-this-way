require 'spec_helper'

describe CategoriesController do
  before(:each) do
    @category = Category.create(name: 'apps')
    @recipe = Recipe.create(name: 'Extreme Pepperoni Pizza', user_id: 1, instructions: 'Bresaola rump tongue.', category_id: @category.id)
  end

  describe 'Category Pages' do
    it 'loads the page' do
      visit '/categories'
      expect(page.status_code).to eq(200)
    end

    it 'shows the user all of the categories' do
      visit '/categories'
      expect(page.body).to include('Apps')
    end

    it 'has an image for each category' do
      visit '/categories'
      expect(page).to have_css("img[src*='#{@recipe.avatar.url}']")
    end

    it 'has a link to each category page' do
      visit '/categories'
      expect(page).to have_link('Apps')
    end

    it 'takes the user to the category show page' do
      visit "/categories/#{@category.slug}"
      expect(page.status_code).to eq(200)
    end

    it 'shows the user all recipes for the category' do
      visit "/categories/#{@category.slug}"
      expect(page).to have_content(@category.recipes.first.name)
    end
  end

end
