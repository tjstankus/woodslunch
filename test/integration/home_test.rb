require 'test_helper'

class HomeTest < ActionDispatch::IntegrationTest

  test 'root path' do
    get '/'
    assert_select 'h2', 'Lunch Ordering'
  end
  
end
