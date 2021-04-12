FactoryBot.define do
  factory :village do
    name { "Testville" }
    zip_code { "00000" }
    insee_code {"00000"}
    email { "village@test.fr" }
    description { "Super village pour y vivre et tout" }
  end
end
