FactoryBot.define do
  factory :user do
    email  { "test@test.fr" }
    password { "testfr" }
    password_confirmation { "testfr" }

    factory :villager do
      email { "villager@test.fr"}
      password { "testfr" }
      password_confirmation { "testfr" }
      role { "villager" }
    end

    factory :town_hall do
      email { "town_hall@test.fr" }
      password { "testfr" }
      password_confirmation { "testfr" }
      role { "town_hall" }
    end
  end
end
