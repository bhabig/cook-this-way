require 'spec_helper'

describe RecipesController do
  before(:each) do
    facebook_login_setup
    visit '/auth/facebook'
    @user = User.last

    @category = Category.create(name: "yummy")
    Category.create(name: "delish")
    @tag = Tag.create(name: "easy-bake")
    Tag.create(name: "home cookin")

    @recipe = Recipe.create(name: 'Extreme Pepperoni Pizza', user_id: @user.id, instructions: 'Bresaola rump tongue, prosciutto cow short ribs corned beef venison short loin tri-tip pork chop. Frankfurter pork beef rump landjaeger sausage tenderloin pastrami salami brisket ground round pork chop filet mignon boudin. Venison fatback prosciutto capicola bresaola doner ham hock shankle jowl pastrami. Andouille meatloaf chuck salami kevin pork loin, ribeye sirloin meatball shankle cow.', category_id: @category.id)

    @ingredient1 = Ingredient.create(name: "Dough", measurement_type: "crust", amount: 1)
    @ingredient2 = Ingredient.create(name: "Pepperoni", measurement_type: "slice", amount: 42)
    @ingredient3 = Ingredient.create(name: "cheese", measurement_type: "cups", amount: 3)

    @recipe.tags << @tag
    @recipe.ingredients << @ingredient1
    @recipe.ingredients << @ingredient2
    @recipe.ingredients << @ingredient3
  end

  describe 'Create New Recipe' do
    it 'redirects a user that is not signed in' do
      visit '/signout'
      visit '/recipes/new'
      expect(page).to have_content('Sign in to access all content')
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
      expect(page.body).to include('recipe[tag_ids][]')
      expect(page.body).to include('ingredient[][name]')
      expect(page.body).to include('ingredient[][amount]')
      expect(page.body).to include('ingredient[][measurement_type]')
      expect(page.body).to include('recipe[instructions]')
    end

    it 'allows the user to add a recipe' do
      visit '/recipes/new'
      fill_in :recipe_name, :with => "Pepperoni Monkey Bread"
      choose "category_#{Category.last.id}"
      check "tag_#{Tag.last.id}"
      fill_in :ingredient_name_1, :with => "Pepperoni"
      fill_in :ingredient_amount_1, :with => 42
      fill_in :ingredient_measurement_1, :with => "slice"
      click_button "Add Another Ingredient"
      click_button "Remove Last Ingredient"
      fill_in :recipe_instructions, :with => "Make it. Cook it. Eat it."
      click_button "Add Recipe"
      recipe = Recipe.last

      expect(recipe.name).to eq("Pepperoni Monkey Bread")
      expect(recipe.category.name).to eq("delish")
      expect(recipe.tags.first.name).to eq("home cookin")
      expect(recipe.ingredients.first.name).to eq("Pepperoni")
      expect(recipe.instructions).to eq("Make it. Cook it. Eat it.")
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
      expect(page).to have_button('Edit Your Recipe')
    end

    it 'allows users to make a recipe their own' do
      visit '/signout'
      visit "/recipes/#{@recipe.id}/#{@recipe.slug}"
      expect(page).to have_content('Make It Your Own')
    end
  end

end
