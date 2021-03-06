require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'iOS App Usage'" do
      visit root_path
      expect(page).to have_content('iOS App Usage')
    end
  

    it "should have the title 'Home'" do
      visit root_path
      expect(page).to have_title("iOS App Usage | Home")
    end
  
  end
end