class StudentOrder

  # Presenter
  include ActiveModel::Validations  
  include ActiveModel::Conversion  
  extend ActiveModel::Naming
  def persisted?; false; end;

end
