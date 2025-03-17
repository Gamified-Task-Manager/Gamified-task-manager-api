# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:5173' # ✅ No wildcard, specific origin only

    resource '*',
      headers: :any,
      expose: ['Authorization'], # ✅ Strings, not symbols
      methods: %w[get post put patch delete options head], # ✅ Strings, not symbols
      credentials: true # ✅ Allow credentials
  end
end




