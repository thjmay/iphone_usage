FactoryGirl.define do
  factory :user do
    distinct_id "distinct_id1"
    sk_user_id "1111"
    full_user 1
    transactions 5
    app_version "301"
  end

  factory :event do
    name "Lorem ipsum"
    time 111
    distinct_id "distinct_id1"
    wifi 1
    user
  end
end