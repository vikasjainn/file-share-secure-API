FactoryBot.define do
  factory :user do
    username { Faker::Internet.username}
    email { Faker::Internet.email}
    password { Faker::Internet.password(min_length: 6) }
    password_digest { BCrypt::Password.create(password) }
  end
end
  