FactoryGirl.define do
  factory :bond_master do
    bondid { Faker::Number.number(10) }
    sysid { FactoryGirl.create(:booking).sysid }
    case_pk { FactoryGirl.create(:case_master).case_pk }
    original_bond_amt { Faker::Number.between(1, 100_000) }
    type_id { ['FIN', 'OTHER', ''].sample }
  end
end
