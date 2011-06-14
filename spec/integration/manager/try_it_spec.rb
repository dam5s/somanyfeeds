require 'spec_helper'

describe SoManyFeeds::Manager::TryIt do

  after(:all) do
    User.delete_all
  end

  subject { page }

  context 'from the home page I click on "get started!"' do

    before do
      visit '/'
      click_link_or_button 'get started'
    end

    it { should have_css('li.current', text: 'step 1') }

  end

end
