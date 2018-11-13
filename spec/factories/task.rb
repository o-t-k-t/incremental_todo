FactoryBot.define do
  factory :task do
    sequence(:name) { |n| "task-#{n}" }
    description '何かする'
    association :user, factory: :task_user
  end

  factory :task_user, class: User do
    name '平松隆'
    sequence(:email) { |n| "hiramatsu.takashi1971.#{n}@example.com" }
    password 'ca11back'
    password_digest 'ca11back'
  end

  trait :homework_by_12 do
    name '論文を書く'
    deadline DateTime.new(2018, 11, 12, 13, 14, 15)
    priority 3
  end

  trait :shopping_by_13 do
    name 'パンを買う'
    deadline DateTime.new(2018, 11, 13, 13, 14, 15)
    priority 1
  end

  trait :cleanup do
    name '掃除する'
    priority 2
  end

  trait :no_owner do
    name '論文を書く'
    priority 2
    user nil
  end
end
