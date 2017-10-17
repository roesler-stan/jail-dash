FactoryGirl.define do
  factory :judge do
    slc_id { Faker::Number.hexadecimal(4) }
    extdesc { Faker::Name.name }
  end
end
