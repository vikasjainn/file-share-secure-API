FactoryBot.define do
    factory :post do
      title { Faker::Restaurant.name }
      file { Rack::Test::UploadedFile.new( 'spec/fixtures/files/testing.txt', 'text/plain') }
      association :user, factory: :user
    end
end