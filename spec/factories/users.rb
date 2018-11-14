FactoryBot.define do
  factory :user do
    name { '平松隆' }
    email { 'hiramatsu.takashi1972@example.com' }
    password 'ca11back'
    password_confirmation 'ca11back'
  end
end
