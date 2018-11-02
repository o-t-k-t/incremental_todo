FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "task-#{n}" }
    description 'Do something'
  end
  trait :homework do
    name 'Wirte a paper'
  end

  trait :shopping do
    name 'Buy a bread'
  end
end
