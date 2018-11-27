FactoryBot.define do
  factory :label do
    name { 'MyString' }
    description { 'MyText' }
    color { :yellow }
  end
end
