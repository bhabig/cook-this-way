# Create users
5.times do
  user = User.create(
    provider: "facebook",
    uid: Faker::Number.between(100000, 1000000),
    name: Faker::Name.name,
    email: Faker::Internet.safe_email,
    oauth_token: Faker::Lorem.characters(30),
    oauth_expires_at: Faker::Time.forward(30, :morning)
  )
end
# Create ingredients
200.times do
  ingredient = Ingredient.create(name: Faker::StarWars.specie, measurement_type: Faker::Hacker.noun, amount: Faker::Number.decimal(1, 2))
end

# Create Tags
tag1 = Tag.create(name: 'hot')
tag2 = Tag.create(name: 'cold')
tag3 = Tag.create(name: 'vegan')
tag4 = Tag.create(name: 'vegetarian')
tag5 = Tag.create(name: 'low-carb')
tag6 = Tag.create(name: 'seafood')
tag7 = Tag.create(name: 'chicken')
tag8 = Tag.create(name: 'beef')
tag9 = Tag.create(name: 'kosher')

# Create Categories
Category.create(name: 'apps')
Category.create(name: 'soups')
Category.create(name: 'salads')
Category.create(name: 'entrees')
Category.create(name: 'desserts')
Category.create(name: 'beverages')

# Create Recipes
30.times do
  instructions = "Bresaola rump tongue, prosciutto cow short ribs corned beef venison short loin tri-tip pork chop. Frankfurter pork beef rump landjaeger sausage tenderloin pastrami salami brisket ground round pork chop filet mignon boudin.
  Pancetta pig sirloin, sausage biltong t-bone bresaola doner drumstick boudin ham pork. Picanha doner alcatra kielbasa salami. Corned beef porchetta pig, beef leberkas pastrami sausage cow alcatra pork chop shank shankle drumstick hamburger.\n
  Turducken pastrami rump tongue turkey shank chicken pancetta bacon ham hamburger. Chicken ham hock corned beef short loin capicola, shoulder turducken alcatra ball tip turkey meatball bacon drumstick shankle boudin. Corned beef pancetta frankfurter, jerky picanha jowl chuck.\n
  Ball tip alcatra short ribs turducken ham hock strip steak flank beef landjaeger kevin chuck doner!"
  recipe = Recipe.create(name: Faker::Book.title, instructions: instructions, user_id: Faker::Number.between(1, 6), category_id: Faker::Number.between(1, 6))

  3.times do
    tag = Tag.find_by_id(Faker::Number.between(1, 9))
    recipe.tags << tag unless recipe.tags.include?(tag)
  end

  5.times do
    ingredient = Ingredient.find_by_id(Faker::Number.between(1, 200))
    recipe.ingredients << ingredient unless recipe.ingredients.include?(ingredient)
  end
end
