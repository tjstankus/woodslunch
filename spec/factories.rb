FactoryGirl.define do

  factory :user do
    sequence :email do |n|
      "#{Faker::Name.first_name}.#{Faker::Name.last_name}#{n}@example.com".
        downcase
    end
    password 'secret'
  end

  factory :admin, :parent => :user do
    roles { [:admin] }
  end

  factory :menu_item do
    sequence(:name) {|n| "Menu item #{n}"}
    price { MenuItem::DEFAULT_PRICE }
  end

  factory :daily_menu_item do
    association :menu_item
    day_of_week { DayOfWeek.first }
  end

  factory :student do
    association :user
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
    grade Student::GRADES.sample
  end

  factory :order do
    association :student
    served_on { Date.civil(2011, 4, 1) }
  end
end
