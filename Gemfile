source "https://rubygems.org"

gem "rails", "~> 8.0.2"

# For secure password hashing
gem 'bcrypt', '~> 3.1.7'

# Boosts boot speed by caching expensive operations
gem "bootsnap", require: false

# For encoding and decoding JSON Web Tokens (JWT) for authentication
gem "jwt"

# For serializing data to JSON API format
gem "jsonapi-serializer"

# For deploying and managing containers in production
gem "kamal", require: false

# PostgreSQL database adapter for ActiveRecord
gem "pg", "~> 1.1"

# Puma web server for better performance
gem "puma", ">= 5.0"

# Middleware to handle Cross-Origin Resource Sharing (CORS) requests
gem "rack-cors"

# Redis client for handling in-memory data structures and background jobs
gem "redis"

# Swagger documentation for API endpoints
gem "rswag"

# Background job processing framework
gem "sidekiq"

# Caching library for fast data retrieval
gem "solid_cache"

# Real-time WebSocket communication for Rails
gem "solid_cable"

# Background job processing similar to Sidekiq but native to Rails
gem "solid_queue"

# CLI tool for running Rails applications remotely
gem "thruster", require: false

# Time zone data for handling time zones on Windows and JRuby platforms
gem "tzinfo-data", platforms: %i[windows jruby]

# ========================
# Development and test gems
# ========================

group :development, :test do
  # For creating test data in tests
  gem "factory_bot_rails"
  
  # For generating fake data in tests
  gem "faker"
  
  # RSpec testing framework for Rails
  gem "rspec-rails", "~> 7.1"
  
  # Provides RSpec matchers for testing model relationships and validations
  gem "shoulda-matchers"
  
  # For tracking test coverage
  gem "simplecov", require: false

  # Static code analyzer for security vulnerabilities
  gem "brakeman", require: false

  # Interactive debugging tool for Ruby
  gem "debug", platforms: %i[mri windows], require: "debug/prelude"

  # Load environment variables from `.env` files
  gem "dotenv-rails"

  # Rubocop configuration tailored for Rails
  gem "rubocop-rails-omakase", require: false
end

gem "dockerfile-rails", ">= 1.7", :group => :development
