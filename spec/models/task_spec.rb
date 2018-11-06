require 'spec_helper'

RSpec.describe Task, type: :model do
  using RSpec::Parameterized::TableSyntax

  describe `#valid?` do
    context 'when typical parameter received' do
      it 'passes' do
        travel_to(DateTime.new(2018, 11, 12, 13, 14, 15)) do
          expect(
            Task.new(
              name: '靴を買う',
              description: '靴屋に靴を買いに行く',
              deadline: DateTime.new(2018, 11, 15, 10, 15, 30)
            )
          ).to be_valid
        end
      end
    end

    context 'name' do
      where(:name, :be_valid?) do
        '靴' *   0 | be_invalid
        '靴' *   1 | be_valid
        '靴' * 255 | be_valid
        '靴' * 256 | be_invalid
      end

      with_them do
        it { expect(Task.new(name: name, description: '靴屋に靴を買いに行く')).to be_valid? }
      end
    end

    context 'description' do
      where(:description, :be_valid?) do
        '靴' *    0 | be_valid
        '靴' *    1 | be_valid
        '靴' * 2000 | be_valid
        '靴' * 2001 | be_invalid
      end

      with_them do
        it { expect(Task.new(name: '靴を買う', description: description)).to be_valid? }
      end
    end

    context 'deadline' do
      where(:deadline, :be_valid?) do
        DateTime.new(1993,  2, 24, 12, 30, 45) | be_invalid
        DateTime.new(2018, 11, 12, 13, 14, 15) | be_invalid
        DateTime.new(2018, 11, 12, 13, 14, 16) | be_valid
        DateTime.new(2032,  5,  6, 12, 34, 56) | be_valid
      end

      with_them do
        it do
          travel_to(DateTime.new(2018, 11, 12, 13, 14, 15)) do
            expect(Task.new(name: '靴を買う', deadline: deadline)).to be_valid?
          end
        end
      end
    end
  end
end
