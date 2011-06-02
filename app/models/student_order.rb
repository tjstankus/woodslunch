class StudentOrder

  # Presenter
  include ActiveModel::Validations  
  include ActiveModel::Conversion  
  extend ActiveModel::Naming
  def persisted?; false; end;

  attr_accessor :student_id, :year, :month

  validates :student_id, :presence => true

  def initialize(params)
    @student_id = params['student_id'] || nil 
    @year = params['year'] || Date.today.year
    @month = params['month'] || Date.today.month
  end

  def student
    @student ||= Student.find(student_id)
  end

end
