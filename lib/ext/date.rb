require 'date'

class Date

  def weekday?
    self.cwday < 6
  end

end
