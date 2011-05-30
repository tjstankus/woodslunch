# coding: utf-8
#
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

if Rails.env.development?
  User.find_or_create_by_email('user@example.com', :password => 'secret')

  admin_email = 'admin@example.com'
  unless User.find_by_email(admin_email)
    User.new(:email => admin_email, :password => 'secret').tap do |u|
      u.roles = [:admin]
      u.save!
    end
  end
end

DayOfWeek::NAMES.each do |day_name|
  DayOfWeek.find_or_create_by_name(day_name)
end

menu_items_by_day = {
  'Monday' => [
    'Hamburger',
    'Cheeseburger',
    'Hot Dog',
    'Veggie Burger',
    'Entrée Salad',
    'Cali Sushi Roll',
    'Veggie Sushi Roll'
  ],
  'Tuesday' =>  [
    'Chicken Fajitas',
    'Indian Chicken',
    'Indian Veggie',
    'Grilled Cheese',
    'Chile con Queso'
  ],
  'Wednesday' => [
    'Chick-fil-A Sandwich',
    'Chick-fil-A Nuggets',
    'Entrée Salad'
  ],
  'Thursday' => [
    'Italian Sub',
    'Club Sub',
    'Turkey Sub',
    'Veggie Sub',
    'Cheese Burrito'
  ],
  'Friday' => [
    'Cheese Pizza',
    'Pepperoni Pizza',
    'Entrée Salad'
  ]
}

menu_items_by_day.each do |day_name, item_names|
  day = DayOfWeek.find_by_name(day_name)
  item_names.each do |item_name|
    menu_item = MenuItem.find_or_create_by_name(item_name)
    unless day.menu_items.include?(menu_item)
      DailyMenuItem.create!(:day_of_week => day, :menu_item => menu_item)
    end
  end
end

