require 'spec_helper'

describe RecipesController do
  before do
    @recipe = Recipe.create(name: 'Extreme Pepperoni Pizza', user_id: 1, instructions: 'Bresaola rump tongue, prosciutto cow short ribs corned beef venison short loin tri-tip pork chop. Frankfurter pork beef rump landjaeger sausage tenderloin pastrami salami brisket ground round pork chop filet mignon boudin. Venison fatback prosciutto capicola bresaola doner ham hock shankle jowl pastrami. Andouille meatloaf chuck salami kevin pork loin, ribeye sirloin meatball shankle cow.')

    @user = User.create(
      provider: "facebook",
      uid: 18616540,
      name: 'Bobby Jones',
      email: 'bob@example.com',
      oauth_token: 'abfuibsdfbkufgebkufbib',
      oauth_expires_at: (Date.new + 1.month).strftime("%Y-%m-%d")
    )
  end

  it 'loads the recipes index' do
    get '/recipes'
    expect(last_response.status).to eq(200)
  end

  describe "recipe show pages" do
    describe "/recipes/:slug" do
      before do
        visit "/recipes/#{@recipe.slug}"
      end

      it 'responds with a 200 status code' do
        expect(page.status_code).to eq(200)
      end

      it "displays the recipe's name" do
        expect(page).to have_content(@recipe.name)
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

    end
  end

end
