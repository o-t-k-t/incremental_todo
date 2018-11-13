FactoryBot.define do
  factory :user do
    name { '平松隆' }
    email { 'hitamatsu.takashi1972@example.com' }
    password 'ca11back'
    password_digest 'ca11back'
  end
end
