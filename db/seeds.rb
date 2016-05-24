# Create Categories
Category.create(name: 'appetizers')
Category.create(name: 'soups')
Category.create(name: 'salads')
Category.create(name: 'entrees')
Category.create(name: 'desserts')
Category.create(name: 'beverages')


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

# Heroku users
User.create(
  provider: "facebook",
  uid: Faker::Number.between(100000, 1000000),
  name: "Prince Thor",
  email: Faker::Internet.safe_email("mighty.thor"),
  oauth_token: Faker::Lorem.characters(30),
  oauth_expires_at: Faker::Time.forward(30, :morning)
)
User.create(
  provider: "facebook",
  uid: Faker::Number.between(100000, 1000000),
  name: "Steve Rogers",
  email: Faker::Internet.safe_email("steve.rogers"),
  oauth_token: Faker::Lorem.characters(30),
  oauth_expires_at: Faker::Time.forward(30, :morning)
)
User.create(
  provider: "facebook",
  uid: Faker::Number.between(100000, 1000000),
  name: "Tony Stark",
  email: Faker::Internet.safe_email("tony.stark"),
  oauth_token: Faker::Lorem.characters(30),
  oauth_expires_at: Faker::Time.forward(30, :morning)
)
User.create(
  provider: "facebook",
  uid: Faker::Number.between(100000, 1000000),
  name: "Bruce Banner",
  email: Faker::Internet.safe_email("bruce.banner"),
  oauth_token: Faker::Lorem.characters(30),
  oauth_expires_at: Faker::Time.forward(30, :morning)
)
User.create(
  provider: "facebook",
  uid: Faker::Number.between(100000, 1000000),
  name: "Natasha Romanoff",
  email: Faker::Internet.safe_email("natasha.romanoff"),
  oauth_token: Faker::Lorem.characters(30),
  oauth_expires_at: Faker::Time.forward(30, :morning)
)
User.create(
  provider: "facebook",
  uid: Faker::Number.between(100000, 1000000),
  name: "Clint Barton",
  email: Faker::Internet.safe_email("clint.barton"),
  oauth_token: Faker::Lorem.characters(30),
  oauth_expires_at: Faker::Time.forward(30, :morning)
)
User.create(
  provider: "facebook",
  uid: Faker::Number.between(100000, 1000000),
  name: "Nick Fury",
  email: Faker::Internet.safe_email("nick.fury"),
  oauth_token: Faker::Lorem.characters(30),
  oauth_expires_at: Faker::Time.forward(30, :morning)
)
User.create(
  provider: "facebook",
  uid: Faker::Number.between(100000, 1000000),
  name: "Maria Hill",
  email: Faker::Internet.safe_email("maria.hill"),
  oauth_token: Faker::Lorem.characters(30),
  oauth_expires_at: Faker::Time.forward(30, :morning)
)
User.create(
  provider: "facebook",
  uid: Faker::Number.between(100000, 1000000),
  name: "Phil Coulson",
  email: Faker::Internet.safe_email("phil.coulson"),
  oauth_token: Faker::Lorem.characters(30),
  oauth_expires_at: Faker::Time.forward(30, :morning)
)
User.create(
  provider: "facebook",
  uid: Faker::Number.between(100000, 1000000),
  name: "Pepper Potts",
  email: Faker::Internet.safe_email("pepper.potts"),
  oauth_token: Faker::Lorem.characters(30),
  oauth_expires_at: Faker::Time.forward(30, :morning)
)
User.create(
  provider: "facebook",
  uid: Faker::Number.between(100000, 1000000),
  name: "Wanda Maximoff",
  email: Faker::Internet.safe_email("wanda.maximoff"),
  oauth_token: Faker::Lorem.characters(30),
  oauth_expires_at: Faker::Time.forward(30, :morning)
)
User.create(
  provider: "facebook",
  uid: Faker::Number.between(100000, 1000000),
  name: "James Rhodes",
  email: Faker::Internet.safe_email("james.rhodes"),
  oauth_token: Faker::Lorem.characters(30),
  oauth_expires_at: Faker::Time.forward(30, :morning)
)
User.create(
  provider: "facebook",
  uid: Faker::Number.between(100000, 1000000),
  name: "Sam Wilson",
  email: Faker::Internet.safe_email("sam.wilson"),
  oauth_token: Faker::Lorem.characters(30),
  oauth_expires_at: Faker::Time.forward(30, :morning)
)
# Create ingredients
200.times do

  ingredient = Ingredient.create(name: Faker::Hipster.word, measurement_type: Faker::Hacker.noun, amount: Faker::Number.between(1, 4))
end


# Create Recipes
user_ids = [1,3,4,5,6,7,8,9,10,11,12,13,14,15]
50.times do
  instructions = Faker::Hipster.paragraphs.join("\n")
  name = Faker::Beer.hop + " " + Faker::Hacker.adjective + " " + Faker::Team.creature
  recipe = Recipe.create(name: name, instructions: instructions, user_id: user_ids.sample, category_id: Faker::Number.between(1, 6))
  recipe.save!

  5.times do
    ingredient = Ingredient.find_by_id(Faker::Number.between(1, 200))
    recipe.ingredients << ingredient unless recipe.ingredients.include?(ingredient)
  end
end
