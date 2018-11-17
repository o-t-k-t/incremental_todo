require 'rails_helper'

RSpec.describe User, type: :model do
  using RSpec::Parameterized::TableSyntax

  describe `#valid?` do
    context 'name' do
      where(:name, :be_valid?) do
        '靴' *   0 | be_invalid
        '靴' *   1 | be_valid
        '靴' * 255 | be_valid
        '靴' * 256 | be_invalid
      end

      with_them do
        it do
          user = User.new(name: name,
                          email: 'hisamatsu@example.com',
                          password: 'ca11back',
                          password_digest: 'ca11back')
          expect(user).to be_valid?
        end
      end
    end

    context 'email' do
      where(:email, :be_valid?) do
        'hisamatsu.takashi1972@example.com'   | be_valid
        'hisamatsu.takashi1972.@example.com'  | be_invalid
        'hisamatsu.ta(ka)shi1972@example.com' | be_invalid
        'hisamatsu.takashi1972example.com'    | be_invalid
        'hisamatsu.takashi1972@example'       | be_invalid
      end

      with_them do
        it do
          user = User.new(name: '平松隆',
                          email: email,
                          password: 'ca11back',
                          password_confirmation: 'ca11back')
          expect(user).to be_valid?
        end
      end
    end

    context 'password_digest' do
      where(:password, :be_valid?) do
        'l' *  5   | be_invalid
        'l' *  6   | be_valid
        'l' * 20   | be_valid
        'l' * 21   | be_invalid
        'call1back'   | be_valid
        '@;<>/[]~-'   | be_valid
      end

      with_them do
        it do
          user = User.new(name: '平松隆',
                          email: 'hitamatsu@example.com',
                          password: password,
                          password_confirmation: password)
          expect(user).to be_valid?
        end
      end
    end
  end

  context 'delete admin user' do
    where(:number_of_administrators, :be_successed?) do
      1 | be_falsey
      2 | be_truthy
    end

    with_them do
      it do
        number_of_administrators.times { create(:user, :unique, :admin) }
        expect(User.first.destroy).to be_successed?
      end
    end
  end


  describe `#authenticate` do
    context 'when creation' do
      where(:password, :password_confirmation, :be_successful?) do
        'ca11back' | 'ca11back' | be_truthy
        'ca11back' | 'misinput' | be_falsey
        'ca11back' | 'Ca11back' | be_falsey
        'ca11back' | 'ca_11back' | be_falsey
      end

      with_them do
        it do
          user = User.new(name: '平松隆',
                          email: 'hitamatsu@example.com',
                          password: password,
                          password_confirmation: password_confirmation)
          expect(user.save).to be_successful?
        end
      end
    end
  end

  context 'when authentication' do
    where(:password, :auth_password, :be_authenticated?) do
      'ca11back' | 'ca11back'  | be_truthy
      'ca11back' | 'misinput'  | be_falsey
      'ca11back' | 'Ca11back'  | be_falsey
      'ca11back' | 'ca_11back' | be_falsey
    end

    with_them do
      it do
        user = User.create!(name: '平松隆',
                            email: 'hitamatsu@example.com',
                            password: password,
                            password_confirmation: password)
        expect(user.authenticate(auth_password)).to be_authenticated?
      end
    end
  end
end
