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
