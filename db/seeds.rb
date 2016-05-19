# # Create users
# 5.times do
#   id = Faker::Number.between(100000, 1000000)
#   email = Faker::Internet.safe_email
#   name = Faker::Name.name
#   token = Faker::Lorem.characters(30)
#   token_expires = Faker::Time.forward(30, :morning)
#   user = User.create(
#     provider: "facebook",
#     uid: Faker::Number.between(100000, 1000000),
#     name: Faker::Name.name,
#     email: Faker::Internet.safe_email,
#     oauth_token: Faker::Lorem.characters(30),
#     oauth_expires_at: Faker::Time.forward(30, :morning)
#   )
# end
# # Create ingredients
# 200.times do
#   name = Faker::StarWars.specie
#   measure = Faker::Hacker.noun
#   amount = Faker::Number.decimal(1, 2)
#   ingredient = Ingredient.create(name: Faker::StarWars.specie, measurement_type: Faker::Hacker.noun, amount: Faker::Number.decimal(1, 2))
# end
#
# # Create Recipes
# 20.times do
#   title = Faker::Book.title
#   user_id = Faker::Number.between(1, 6)
#   recipe = Recipe.create(title: Faker::Book.title, user_id: Faker::Number.between(1, 6))
#
#   5.times do
#     ingredient = Ingredient.find_by_id(Faker::Number.between(1, 200))
#     recipe.ingredients << ingredient unless recipe.ingredients.include?(ingredient)
#   end
# end
