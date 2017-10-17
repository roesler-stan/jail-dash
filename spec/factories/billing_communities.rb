FactoryGirl.define do
  factory :billing_community do
    id_guid { Faker::Number.number(10) }
    extdesc { Faker::Address.community }
  end
end
