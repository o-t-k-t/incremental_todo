require 'spec_helper'

RSpec.describe Task, type: :model do
  using RSpec::Parameterized::TableSyntax

  describe `#valid?` do
    it 'passes when typical parameter received' do
      expect(Task.new(name: '靴を買う', description: '靴屋に靴を買いに行く')).to be_valid
    end
  end

  where(:name, :be_valid?) do
    '靴' *   0 | be_invalid
    '靴' *   1 | be_valid
    '靴' * 255 | be_valid
    '靴' * 256 | be_invalid
  end

  with_them do
    it { expect(Task.new(name: name, description: '靴屋に靴を買いに行く')).to be_valid? }
  end

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
