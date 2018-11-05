FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "task-#{n}" }
    description '何かする'
  end
  trait :homework do
    name '論文を書く'
  end

  trait :shopping do
    name 'パンを買う'
  end

  trait :cleanup do
    name '掃除する'
  end
end
