namespace :woodslunch do
  desc 'Increment all student grades'
  task :increment_grades => :environment do
    Student.all.each do |student|
      student.increment_grade
    end
  end
end
