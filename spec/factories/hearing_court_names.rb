FactoryGirl.define do
  factory :hearing_court_name do
    slc_id { Faker::Number.hexadecimal(4) }
    extdesc { Faker::Address.community }
  end
end
