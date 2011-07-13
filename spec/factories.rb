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