# # Create users
# 5.times do
#   id = Faker::Number.between(100000, 1000000)
#   email = Faker::Internet.safe_email
#   name = Faker::Name.name
#   token = Faker::Lorem.characters(30)
#   token_expires = Faker::Time.forward(30, :morning)
#   user = User.new(
#     provider: "facebook",
#     uid: id,
#     name: name,
#     email: email,
#     oauth_token: token,
#     oauth_expires_at: token_expires
#   )
#   user.save
# end

# Create Recipes
# 32.times do
#   title = Faker::Book.title
#   user_id = Faker::Number.between(1, 8)
#   recipe = Recipe.new(title: title, user_id: user_id)
#   recipe.save
# end

# Create ingredients
500.times do
  name = Faker::StarWars.specie
  measure = Faker::Hacker.noun
  amount = Faker::Number.decimal(1, 2)
  ingredient = Ingredient.create(name: name, measurement_type: measure, amount: amount)

end
