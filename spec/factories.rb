FactoryGirl.define do

  factory :user do
    sequence :email do |n|
      # WTF do I need to do to ensure uniqueness
      "#{Faker::Name.first_name}.#{Faker::Name.last_name}" + 
      "-#{SecureRandom.hex(4)}#{rand(10000)}#{n}@example.com".
        downcase
    end
    password 'secret'
  end

  factory :admin, :parent => :user do
    roles { [:admin] }
  end

  factory :menu_item do
  	name 'Grilled cheese'
    price { MenuItem::DEFAULT_PRICE }
  end

  factory :daily_menu_item do
    association :menu_item
    day_of_week { DayOfWeek.first }
  end

end
