Factory.sequence :email_suffix do |n|
  "#{n}@example.com"
end

Factory.define :account do |f|
  f.balance 0
end

Factory.define :user do |f|
  f.association :account, :factory => :account
  f.first_name  Faker::Name.first_name
  f.last_name Faker::Name.last_name
  f.password 'secret'
  f.after_build do |user|
    suffix = Factory.next :email_suffix
    user.email = "#{user.first_name}.#{user.last_name}#{suffix}"
  end
end

Factory.define :admin, :parent => :user do |f|
  f.roles { [:admin] }
end

Factory.define :menu_item do |f|
  f.sequence(:name) { |n| "Menu item #{n}" } 
  f.price { MenuItem::DEFAULT_PRICE }
end

Factory.define :daily_menu_item do |f|
  f.association :menu_item, :factory => :menu_item
  f.day_of_week { DayOfWeek.first }
end

Factory.define :student do |f|
  f.association :account, :factory => :account
  f.first_name Faker::Name.first_name
  f.last_name Faker::Name.last_name
  f.grade Student::GRADES.sample
end

Factory.define :order do |f|
  f.association :student, :factory => :student
  f.served_on { Date.civil(2011, 4, 1) }
  f.total 0
end

Factory.define :ordered_menu_item do |f|
  f.association :order, :factory => :order
  f.association :menu_item, :factory => :menu_item
end

# FactoryGirl.define do
# 
#   factory :account do
#     balance 0
#   end
# 
#   factory :user do
#     association :account
#     first_name Faker::Name.first_name
#     last_name Faker::Name.last_name
#     sequence(:email) {|n| "#{first_name}.#{last_name}#{n}@example.com".downcase}
#     password 'secret'
#     after_build do |user|
#       
#     end
#   end
# 
#   factory :admin, :parent => :user do
#     roles { [:admin] }
#   end
# 
#   factory :menu_item do
#     sequence(:name) {|n| "Menu item #{n}"}
#     price { MenuItem::DEFAULT_PRICE }
#   end
# 
#   factory :daily_menu_item do
#     association :menu_item
#     day_of_week { DayOfWeek.first }
#   end
# 
#   factory :student do
#     association :account
#     first_name Faker::Name.first_name
#     last_name Faker::Name.last_name
#     grade Student::GRADES.sample
#   end
# 
#   factory :order do
#     association :student
#     served_on { Date.civil(2011, 4, 1) }
#     total 0
#   end
# 
#   factory :ordered_menu_item do
#     association :order
#     association :menu_item
#   end
# end
