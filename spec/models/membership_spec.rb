require 'rails_helper'

RSpec.describe Membership, type: :model do
  using RSpec::Parameterized::TableSyntax

  let(:user) { create(:user) }
  let(:group) { create(:group) }

  describe `#valid?` do
    context 'When initail parameters shake' do
      where(:role, :be_valid?, :expected_exception) do
        0 | be_valid | nil
        1 | be_valid | nil
        2 | nil      | ArgumentError
      end

      with_them do
        it do
          if expected_exception
            expect { Membership.new(user: user, group: group, role: role) }.to raise_error(ArgumentError)
          else
            expect(Membership.new(user: user, group: group, role: role)).to be_valid?
          end
        end
      end
    end

    context 'When the user registers same group 2 times' do
      it 'rejects' do
        expect(Membership.create(user: user, group: group, role: :general)).to be_truthy
        expect(Membership.new(user: user, group: group, role: :general)).to be_invalid
      end
    end
  end

  describe `#destroy` do
    let(:user) { create(:user) }
    let(:group) { create(:group) }

    context 'When someone passes a group' do
      where(:role, :after_count) do
        0 | 0
        1 | 1
      end

      with_them do
        it do
          ug = Membership.create!(user: user, group: group, role: role)
          ug.destroy
          expect(Membership.all.size).to eq(after_count)
        end
      end
    end
  end
end
