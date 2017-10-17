FactoryGirl.define do
  factory :arrest do
    slc_id { Faker::Number.hexadecimal(3) } # this ID sometimes contains strings
    extdesc 'Justice League'
  end
end
