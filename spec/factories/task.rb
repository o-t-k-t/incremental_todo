FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "task-#{n}" }
    description { '何かする' }
  end
end
