require 'spec_helper'

describe Event do

  let(:user) { FactoryGirl.create(:user) }
  before do
    @event = Event.new(name: "Lorem ipsum", user_id: user.id, time: 111, wifi: 1, distinct_id: user.distinct_id)
  end

  subject { @event }

  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:time) }
  it { should respond_to(:wifi) }
  it { should respond_to(:distinct_id) }
  it { should respond_to(:user) }
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @event.user_id = nil }
    it { should_not be_valid }
  end

end