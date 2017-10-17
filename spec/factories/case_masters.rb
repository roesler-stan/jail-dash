FactoryGirl.define do
  factory :case_master do
    case_pk { Faker::Number.number(10) }
    hearing_court_name { FactoryGirl.create(:hearing_court_name) }
    judge { FactoryGirl.create(:judge) }
    billing_community { FactoryGirl.create(:billing_community) }
    booking { FactoryGirl.create(:booking) }
  end
end
