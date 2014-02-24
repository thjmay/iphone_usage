require 'spec_helper'

describe User do

  before { @user = User.new(distinct_id: "distinct_id", sk_user_id: "1111", full_user: 0, transactions: 9, app_version: "301") }

  subject { @user }

  it { should respond_to(:distinct_id) }
  it { should respond_to(:sk_user_id) }
  it { should respond_to(:full_user) }
  it { should respond_to(:transactions) }
  it { should respond_to(:app_version) }

  describe "when distinct_id is not present" do
    before { @user.distinct_id = " " }
    it { should_not be_valid }
  end

  describe "when distinct_id is already taken" do
    before do
      user_with_same_distinct_id = @user.dup
      user_with_same_distinct_id.distinct_id = @user.distinct_id.downcase
      user_with_same_distinct_id.save
    end

    it { should_not be_valid }
  end

end