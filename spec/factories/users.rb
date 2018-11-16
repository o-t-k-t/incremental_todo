FactoryBot.define do
  factory :user do
    name { '平松隆' }
    email { 'hiramatsu.takashi1972@example.com' }
    password { 'ca11back' }
    password_confirmation { 'ca11back' }
  end

  trait :another_user do
    name { '飯田洋平' }
    email { 'youhei.iida2002@example.com' }
    password { 'c0ntents' }
    password_confirmation { 'c0ntents' }
  end
end
