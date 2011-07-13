class DayOff < ActiveRecord::Base

  validates :name, :presence => true
  validates :starts_on, :presence => true
  validates :ends_on, :presence => true
  validate :start_must_be_on_or_before_end

  def start_must_be_on_or_before_end
    unless (starts_on && ends_on) && (starts_on <= ends_on)
      errors.add(:base, "The starts on date must be on or before the ends on date.")
    end
  end
end
