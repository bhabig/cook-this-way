require 'spec_helper'

describe RecipesController do
  before(:each) do
    facebook_login_setup
    visit '/auth/facebook'
    @user = User.last

    @category = Category.create(name: "yummy")

    @recipe = Recipe.create(name: 'Extreme Pepperoni Pizza', user_id: @user.id, instructions: 'Bresaola rump tongue, prosciutto cow short ribs corned beef venison short loin tri-tip pork chop. Frankfurter pork beef rump landjaeger sausage tenderloin pastrami salami brisket ground round pork chop filet mignon boudin. Venison fatback prosciutto capicola bresaola doner ham hock shankle jowl pastrami. Andouille meatloaf chuck salami kevin pork loin, ribeye sirloin meatball shankle cow.', category_id: @category.id)
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

    it 'lets the user add a recipe' do
      
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
        expect(page).to have_content(@recipe.ingredients.first)
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
