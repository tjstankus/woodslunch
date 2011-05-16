class MenuItem < ActiveRecord::Base

  validates :name, :presence => true
  validates_uniqueness_of :name, :case_sensitive => false
  validates :price, :presence => true, 
                    :numericality => { :message => 'must be a number' }

  DEFAULT_PRICE = 4.00

  after_initialize :set_price_on_new_record

  def set_price_on_new_record
    self.price = DEFAULT_PRICE if self.new_record?
  end

end