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

# Clear out existing data
puts "Clearing existing data..."
UserReward.destroy_all
Task.destroy_all
Reward.destroy_all
Theme.destroy_all
User.destroy_all

# Create Themes
puts "Creating themes..."
dark_mode = Theme.create!(
  name: "Dark Mode",
  description: "A sleek dark theme",
  css_class: "dark-mode"
)

light_mode = Theme.create!(
  name: "Light Mode",
  description: "A bright light theme",
  css_class: "light-mode"
)

# Create Rewards
puts "Creating rewards..."
avatar_reward = Reward.create!(
  name: "Cool Avatar",
  description: "A stylish avatar",
  points_required: 100,
  reward_type: "avatar",
  active: true
)

game_reward = Reward.create!(
  name: "Exclusive Game",
  description: "Unlock this cool game",
  points_required: 200,
  reward_type: "game",
  active: true
)

theme_reward = Reward.create!(
  name: "Premium Theme",
  description: "Upgrade to a premium theme",
  points_required: 150,
  reward_type: "theme",
  active: true
)

# Create Users
puts "Creating users..."
terra = User.create!(
  username: "terra",
  email: "terra@example.com",
  password: "securepassword",
  theme: dark_mode,
  avatar: avatar_reward,
  points: 500
)

alex = User.create!(
  username: "alex",
  email: "alex@example.com",
  password: "password123",
  theme: light_mode,
  avatar: theme_reward,
  points: 300
)

# Create Tasks
puts "Creating tasks..."
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
  description: "Fix the existing bugs in the app",
  points_awarded: 20,
  completed: false,
  due_date: Date.today + 2,
  priority: "low",
  status: "pending"
)

# Assign Rewards to Users via UserReward
puts "Assigning rewards..."
UserReward.create!(
  user: terra,
  reward: game_reward,
  purchased: true,
  unlocked: true
)

UserReward.create!(
  user: alex,
  reward: avatar_reward,
  purchased: true,
  unlocked: false
)

Reward.create!(
  name: 'Golden Donut',
  description: 'Fun new avatar',
  points_required: 50,
  image_url: 'https://example.com/donut.png',
  reward_type: 'avatar',
  active: true
)


puts "Seed data added successfully"
