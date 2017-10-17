FactoryGirl.define do
  factory :booking do
    sysid { Faker::Number.number(10) }
    arrest { FactoryGirl.create(:arrest) }
    comdate { Faker::Date.backward(10_000) } # days; last ~30 years
    reldate {
      [
        Faker::Date.between(100.days.ago, 100.days.from_now),
        Date.parse('1900-01-01') # represents `nil` in this dataset
      ].sample
    }
    jlocat { ['MAIN', 'Lake Wobegon'].sample }
  end
end
