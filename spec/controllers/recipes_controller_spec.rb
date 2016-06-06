require 'spec_helper'
require 'pry-byebug'

describe RecipesController do
  before(:each) do
    create_new_user
    visit '/login'
    fill_in 'email', :with => 'steve.rogers@example.com'
    fill_in 'password', :with => 'password'
    click_button 'Log in'
    User.create(
      name: "Tony Stark",
      email: Faker::Internet.safe_email("tony.stark"),
      password: "password"
    )

    @category = Category.create(name: "yummy")
    Category.create(name: "delish")

    @recipe = Recipe.create(name: 'Extreme Pepperoni Pizza', user_id: 1, instructions: 'Bresaola rump tongue, prosciutto cow short ribs corned beef venison short loin tri-tip pork chop. Frankfurter pork beef rump landjaeger sausage tenderloin pastrami salami brisket ground round pork chop filet mignon boudin. Venison fatback prosciutto capicola bresaola doner ham hock shankle jowl pastrami. Andouille meatloaf chuck salami kevin pork loin, ribeye sirloin meatball shankle cow.', category_id: @category.id)
    @recipe2 = Recipe.create(name: 'Pepperoni Pizza', user_id: 2, instructions: 'Bresaola rump tongue, prosciutto cow short ribs corned beef venison short loin tri-tip pork chop. Frankfurter pork beef rump landjaeger sausage tenderloin pastrami salami brisket ground round pork chop filet mignon boudin. Venison fatback prosciutto capicola bresaola doner ham hock shankle jowl pastrami. Andouille meatloaf chuck salami kevin pork loin, ribeye sirloin meatball shankle cow.', category_id: @category.id)
    @ingredient1 = Ingredient.create(name: "Dough", measurement_type: "crust", amount: 1)
    @ingredient2 = Ingredient.create(name: "Pepperoni", measurement_type: "slice", amount: 42)
    @ingredient3 = Ingredient.create(name: "cheese", measurement_type: "cups", amount: 3)

    @recipe.ingredients << @ingredient1
    @recipe.ingredients << @ingredient2
    @recipe.ingredients << @ingredient3
    @recipe2.ingredients << @ingredient1
  end

  describe 'Create New Recipe' do
    it 'redirects a user that is not signed in' do
      visit '/signout'
      visit '/recipes/new'
      expect(page).to have_content('Sign up to access all these great features!')
    end

    it 'shows logged in users the add a recipe page' do
      visit '/recipes/new'
      expect(page.status_code).to eq(200)
    end

    it 'lets the user to view the add a recipe form' do
      visit '/recipes/new'
      expect(page.body).to include('<form')
      expect(page.body).to include('recipe[name]')
      expect(page.body).to include('recipe[category_id]')
      expect(page.body).to include('ingredient[][name]')
      expect(page.body).to include('ingredient[][amount]')
      expect(page.body).to include('ingredient[][measurement_type]')
      expect(page.body).to include('recipe[instructions]')
    end

    it 'allows the user to add a recipe' do
      visit '/recipes/new'
      fill_in :recipe_name, :with => "Pepperoni Monkey Bread"
      choose "category_#{Category.last.id}"
      fill_in :ingredient_name_1, :with => "Pepperoni"
      fill_in :ingredient_amount_1, :with => 42
      fill_in :ingredient_measurement_1, :with => "slice"
      click_button "Add Another Ingredient"
      click_button "Remove Added Ingredient"
      fill_in :recipe_instructions, :with => "Make it. Cook it. Eat it."
      click_button "Add Recipe"
      recipe = Recipe.last

      expect(recipe.name).to eq("pepperoni monkey bread")
      expect(recipe.category.name).to eq("delish")
      expect(recipe.ingredients.first.name).to eq("pepperoni")
      expect(recipe.instructions).to eq("Make it. Cook it. Eat it.")
    end
  end

  describe 'Edit A Recipe' do
    it 'redirects a user that is not signed in' do
      @recipe = Recipe.first
      visit '/signout'
      visit "/recipes/#{@recipe.id}/#{@recipe.slug}/edit"
      expect(page).to have_content('You must be signed in to edit a recipe.')
    end

    it 'shows logged in users the edit a recipe page' do
      @recipe = Recipe.first
      visit "/recipes/#{@recipe.id}/#{@recipe.slug}/edit"
      expect(page.status_code).to eq(200)
    end

    it 'lets the user to view the edit a recipe form' do
      @recipe = Recipe.first
      visit "/recipes/#{@recipe.id}/#{@recipe.slug}/edit"
      expect(page.body).to include('<form')
      expect(page.body).to include('recipe[name]')
      expect(page.body).to include('recipe[category_id]')
      expect(page.body).to include('ingredient[][name]')
      expect(page.body).to include('ingredient[][amount]')
      expect(page.body).to include('ingredient[][measurement_type]')
      expect(page.body).to include('recipe[instructions]')
    end

    it 'allows the user to edit a recipe' do
      @recipe = Recipe.first
      @user = User.first
      visit "/recipes/#{@recipe.id}/#{@recipe.slug}/edit"
      fill_in :recipe_name, :with => "Pepperoni Monkey Bread"
      choose "category_#{Category.last.id}"
      fill_in :ingredient_name_1, :with => "Pepperoni"
      fill_in :ingredient_amount_1, :with => 42
      fill_in :ingredient_measurement_1, :with => "slice"
      click_button "Add Another Ingredient"
      click_button "Remove Added Ingredient"
      fill_in :recipe_instructions, :with => "Make it. Cook it. Eat it."
      click_on "Save Changes"
      recipe = Recipe.first

      expect(recipe.name).to eq("pepperoni monkey bread")
      expect(recipe.category.name).to eq("delish")
      expect(recipe.ingredients.first.name).to eq("pepperoni")
      expect(recipe.instructions).to eq("Make it. Cook it. Eat it.")
    end
  end

  describe 'Make A Recipe Your Own' do
    it 'redirects a user that is not signed in' do
      @recipe = Recipe.first
      visit '/signout'
      visit "/recipes/#{@recipe.id}/#{@recipe.slug}/makeit"
      expect(page).to have_content('You must be signed in to make a recipe your own.')
    end

    it 'redirects a user that owns the recipe' do
      @recipe = Recipe.first
      visit "/recipes/#{@recipe.id}/#{@recipe.slug}/makeit"
      expect(page).to have_content('That recipe already belongs to you.')
    end

    it 'shows logged in users the make it your recipe page' do
      @recipe = Recipe.first
      visit "/recipes/#{@recipe.id}/#{@recipe.slug}/makeit"
      expect(page.status_code).to eq(200)
    end

    it 'lets the user view the make it your recipe form' do
      @recipe = Recipe.last
      visit "/recipes/#{@recipe.id}/#{@recipe.slug}/makeit"
      expect(page.body).to include('<form')
      expect(page.body).to include('recipe[name]')
      expect(page.body).to include('recipe[category_id]')
      expect(page.body).to include('ingredient[][name]')
      expect(page.body).to include('ingredient[][amount]')
      expect(page.body).to include('ingredient[][measurement_type]')
      expect(page.body).to include('recipe[instructions]')
    end

    it 'allows the user to make a recipe their own' do
      @recipe = Recipe.last
      visit "/recipes/#{@recipe.id}/#{@recipe.slug}/makeit"
      fill_in :recipe_name, :with => "Pepperoni Monkey Bread"
      choose "category_#{Category.last.id}"
      fill_in :ingredient_name_1, :with => "Pepperoni"
      fill_in :ingredient_amount_1, :with => 42
      fill_in :ingredient_measurement_1, :with => "slice"
      click_button "Add Another Ingredient"
      click_button "Remove Added Ingredient"
      fill_in :recipe_instructions, :with => "Make it. Cook it. Eat it."
      click_on "Make It Your Own"
      recipe2 = Recipe.last

      expect(recipe2.name).to eq("pepperoni monkey bread")
      expect(recipe2.category.name).to eq("delish")
      expect(recipe2.ingredients.first.name).to eq("pepperoni")
      expect(recipe2.instructions).to eq("Make it. Cook it. Eat it.")
    end
  end

  it 'loads the recipes index' do
    get '/recipes'
    expect(last_response.status).to eq(200)
  end

  describe "recipe show pages" do
    describe "/recipes/:id/:slug" do
      before do
        visit "/recipes/#{@recipe.id}/#{@recipe.slug}"
      end

      it 'responds with a 200 status code' do
        expect(page.status_code).to eq(200)
      end

      it "displays the recipe's name" do
        expect(page).to have_content(@recipe.user.name)
      end

      it "displays the recipe's creator" do
        @user = User.first
        expect(page).to have_content(@user.name)
      end

      it "displays the recipe's ingredients" do
        expect(page).to have_content(@recipe.ingredients.first.name)
      end

      it "displays the recipe's instructions" do
        expect(page).to have_content(@recipe.instructions)
      end

      it "displays the recipe's category" do
        expect(page).to have_content(@recipe.category.name.titleize)
      end
    end
  end

  describe "User can choose to edit or make a recipe their own" do
    it 'responds with a 200 status code' do
      visit "/recipes/#{@recipe.id}/#{@recipe.slug}"
      expect(page.status_code).to eq(200)
    end

    it 'allows logged in users to edit their recipes' do
      visit "/recipes/#{@recipe.id}/#{@recipe.slug}"
      expect(page).to have_link('Edit Your Recipe')
    end

    it 'allows users to make a recipe their own' do
      visit '/signout'
      visit "/recipes/#{@recipe.id}/#{@recipe.slug}"
      expect(page).to have_link('Make It Your Own')
    end
  end

end
