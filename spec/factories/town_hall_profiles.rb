FactoryBot.define do
  factory :town_hall_profile do
    name { "Mairie de Test" }
    user { create(:town_hall) }
  end
end
