module SessionHelpers

  def sign_in_as(user)
    visit new_user_session_path
    fill_in 'Email', :with => user.email
    fill_in 'Password', :with => 'secret'
    click_button 'Sign in'
    page.should have_xpath('//div[@id="notice"]', :text => 'Signed in successfully.')
  end

  def sign_out
    visit destroy_user_session_path
  end

  def signed_in_as(user)
    sign_in_as user
    yield
    sign_out
  end
end
