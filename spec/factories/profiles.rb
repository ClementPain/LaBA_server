FactoryBot.define do
  factory :profile do
    first_name { "Mme. / M." }
    last_name { "Test" }
    user { create(:villager) }
  end
end
