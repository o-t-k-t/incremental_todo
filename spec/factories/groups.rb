FactoryBot.define do
  factory :group do
    name { 'ユーザー友の会' }
    description { 'みなさんのタスクを見せ合いましょう' }
  end

  trait :other_users do
    after(:create) do |group|
      user = create(:user)
      Membership.create_with_group!(user, group)
    end
  end
end
