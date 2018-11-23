FactoryBot.define do
  factory :user do
    name { '平松隆' }
    sequence(:email) { |n| "hiramatsu.takashi1971.#{n}@example.com" }
    admin { false }
    password { 'ca11back' }
    password_confirmation { 'ca11back' }
  end
end
