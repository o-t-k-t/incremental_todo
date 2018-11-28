require 'rails_helper'

RSpec.describe Group, type: :model do
  using RSpec::Parameterized::TableSyntax

  describe `#valid?` do
    context 'when initail parameters shake' do
      where(:name, :description, :be_valid?) do
        'ユーザー友の会' |'ユーザー同士でタスクを見せ合いましょう' | be_valid
        'ユーザー友の会' |''                                 | be_valid
        'ユ' * 0       |'ユーザー同士でタスクを見せ合いましょう' | be_invalid
        'ユ' * 255     |'ユーザー同士でタスクを見せ合いましょう' | be_valid
        'ユ' * 256     |'ユーザー同士でタスクを見せ合いましょう' | be_invalid
        'ユーザー友の会' |'ユ' * 0                           | be_valid
        'ユーザー友の会' |'ユ' * 2000                        | be_valid
        'ユーザー友の会' |'ユ' * 2001                        | be_invalid
      end

      with_them do
        it { expect(Group.new(name: name, description: description)).to be_valid? }
      end
    end
  end
end
