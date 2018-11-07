FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "task-#{n}" }
    description '何かする'
  end
  trait :homework_by_12 do
    name '論文を書く'
    deadline DateTime.new(2018, 11, 12, 13, 14, 15)
  end

  trait :shopping_by_13 do
    name 'パンを買う'
    deadline DateTime.new(2018, 11, 13, 13, 14, 15)
  end

  trait :cleanup do
    name '掃除する'
  end
end
