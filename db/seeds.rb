# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

puts "🌱 Clearing existing data..."

UserReward.destroy_all
Task.destroy_all
User.destroy_all
Reward.destroy_all
Theme.destroy_all

puts "🎨 Creating themes..."
dark_mode = Theme.create!(
  name: "Dark Mode",
  description: "A sleek dark theme",
  css_class: "dark-mode",
  image_url: "https://example.com/themes/dark.png"
)

light_mode = Theme.create!(
  name: "Light Mode",
  description: "A bright theme with light colors",
  css_class: "light-mode",
  image_url: "https://example.com/themes/light.png"
)

retro_mode = Theme.create!(
  name: "Retro Neon",
  description: "Throwback to the '80s neon style",
  css_class: "retro-neon",
  image_url: "https://example.com/themes/retro.png"
)

puts "🎁 Creating rewards..."

# Avatar Rewards
cool_avatar = Reward.create!(
  name: "Cool Avatar",
  description: "A stylish avatar with sunglasses",
  points_required: 100,
  reward_type: "avatar",
  image_url: "https://example.com/avatars/cool.png",
  active: true
)

golden_donut = Reward.create!(
  name: "Golden Donut",
  description: "Fun new donut avatar",
  points_required: 50,
  reward_type: "avatar",
  image_url: "https://example.com/avatars/donut.png",
  active: true
)

# Game Rewards
exclusive_game = Reward.create!(
  name: "Sprinkle Dash",
  description: "An exclusive sprinkle-themed game",
  points_required: 200,
  reward_type: "game",
  image_url: "https://example.com/games/sprinkle.png",
  active: true
)

memory_game = Reward.create!(
  name: "Memory Match",
  description: "Sharpen your brain with this game",
  points_required: 150,
  reward_type: "game",
  image_url: "https://example.com/games/memory.png",
  active: true
)

# Theme Rewards (match Theme records!)
premium_theme = Reward.create!(
  name: "Retro Neon",
  description: "Upgrade to the retro neon theme",
  points_required: 150,
  reward_type: "theme",
  image_url: retro_mode.image_url,
  active: true
)

puts "🙋 Creating users..."

terra = User.create!(
  username: "terra",
  email: "terra@example.com",
  password: "securepassword",
  theme: dark_mode,
  avatar: cool_avatar,
  points: 500
)

alex = User.create!(
  username: "alex",
  email: "alex@example.com",
  password: "password123",
  theme: light_mode,
  avatar: golden_donut,
  points: 300
)

puts "✅ Creating tasks..."

Task.create!(
  user: terra,
  name: "Finish Project",
  description: "Complete final project work",
  points_awarded: 50,
  completed: false,
  due_date: Date.tomorrow,
  priority: "high",
  status: "pending"
)

Task.create!(
  user: terra,
  name: "Write Documentation",
  description: "Document the project details",
  points_awarded: 30,
  completed: false,
  due_date: Date.tomorrow,
  priority: "medium",
  status: "in_progress"
)

Task.create!(
  user: alex,
  name: "Debug Code",
  description: "Fix bugs in the app",
  points_awarded: 20,
  completed: false,
  due_date: Date.today + 2,
  priority: "low",
  status: "pending"
)

puts "🎁 Assigning rewards..."

UserReward.create!(
  user: terra,
  reward: exclusive_game,
  purchased: true,
  unlocked: true
)

UserReward.create!(
  user: alex,
  reward: cool_avatar,
  purchased: true,
  unlocked: false
)

puts "✅ Seed data added successfully!"
