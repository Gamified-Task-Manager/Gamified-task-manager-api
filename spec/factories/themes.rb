FactoryBot.define do
  factory :theme do
    sequence(:name) { |n| "Theme #{n}" }
    description { "Some description" }
    css_class { "theme-css" }
    image_url { "http://example.com/image.png" }
  end
end
