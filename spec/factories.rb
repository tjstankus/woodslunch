FactoryGirl.define do

  factory :user do
    sequence :email do |n|
      "#{Faker::Name.first_name}.#{Faker::Name.last_name}#{n}@example.com".
        downcase
    end
    password 'secret'
  end

  factory :admin, :parent => :user do
    role 'admin'
  end

end
