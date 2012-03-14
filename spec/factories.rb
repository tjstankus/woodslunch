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

Factory.define :daily_menu_item_availability do |f|
  f.association :daily_menu_item, :factory => :daily_menu_item
  f.starts_on Date.today.beginning_of_month + 1.month
  f.available true
end

Factory.define :student do |f|
  f.association :account, :factory => :account
  f.first_name Faker::Name.first_name
  f.last_name Faker::Name.last_name
  f.grade Student::GRADES.sample
end

Factory.define :student_order do |f|
  f.served_on { Date.civil(2011, 9, 12) }
  f.association :student, :factory => :student
end

Factory.define :user_order do |f|
  f.served_on { Date.civil(2011, 9, 12) }
  f.association :user, :factory => :user
end

Factory.define :ordered_menu_item do |f|
  f.association :order, :factory => :student_order
  f.association :menu_item, :factory => :menu_item
  f.quantity 1
end

Factory.define :account_request do |f|
  f.first_name  Faker::Name.first_name.downcase
  f.last_name Faker::Name.last_name.downcase
  f.after_build do |acc_req|
    suffix = Factory.next :email_suffix
    acc_req.email = "#{acc_req.first_name}.#{acc_req.last_name}#{suffix}"
  end
end

Factory.define :requested_student do |f|
  f.association :account_request, :factory => :account_request
  f.first_name  Faker::Name.first_name
  f.last_name Faker::Name.last_name
  f.grade 'K'
end

Factory.define :day_off do |f|
  f.name 'Fall Break'
  f.starts_on '2011-11-22'
  f.ends_on '2011-11-25'
end

Factory.define :payment do |f|
  f.association :account, :factory => :account
  f.amount 20.00
end
