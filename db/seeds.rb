# # Create Categories
# Category.create(name: 'appetizers')
# Category.create(name: 'soups')
# Category.create(name: 'salads')
# Category.create(name: 'entrees')
# Category.create(name: 'desserts')
# Category.create(name: 'beverages')


# # Create users
# 5.times do
#   first_name = Faker::Name.first_name
#   last_name = Faker::Name.last_name
#   user = User.create(
#     provider: "facebook",
#     uid: Faker::Number.between(100000, 1000000),
#     name: first_name + " " + last_name,
#     email: Faker::Internet.safe_email(first_name + "." + last_name),
#     oauth_token: Faker::Lorem.characters(30),
#     oauth_expires_at: Faker::Time.forward(30, :morning)
#   )
# end


# Create ingredients
5.times do

  ingredient = Ingredient.create(name: Faker::Hipster.word, measurement_type: Faker::Hacker.noun, amount: Faker::Number.between(1, 4))
end


# Create Recipes
1.times do
  instructions = Faker::Hipster.paragraph(3) + "\n" + Faker::Hipster.paragraph(3) + "\n" + Faker::Hipster.paragraph(3) + "\n" + Faker::Hipster.paragraph(3)
  name = Faker::Beer.hop + " " + Faker::Hacker.adjective + " " + Faker::Team.creature
  recipe = Recipe.create(name: name, instructions: instructions, user_id: Faker::Number.between(1, 6), category_id: Faker::Number.between(1, 6))
  recipe.avatar = File.new(ApplicationController.public_folder + "/images/missing.jpg")
  recipe.save!

  5.times do
    ingredient = Ingredient.find_by_id(Faker::Number.between(1, 200))
    recipe.ingredients << ingredient unless recipe.ingredients.include?(ingredient)
  end
end
