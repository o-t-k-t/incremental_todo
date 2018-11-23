require 'rails_helper'

RSpec.feature '管理画面', type: :feature do
  using RSpec::Parameterized::TableSyntax

  let!(:user) do
    create(:user,
           name: '平松隆',
           email: 'hiramatsu.takashi1971@example.com',
           admin: true,
           password: 'ja5mintea',
           password_confirmation: 'ja5mintea')
  end
  let!(:task) { create(:task, user: user) }

  before do
    visit root_path

    fill_in 'Email', with: 'hiramatsu.takashi1971@example.com'
    fill_in 'Password', with: 'ja5mintea'
    click_on 'Enter'

    visit admin_users_path
  end

  feature 'ユーザ一覧' do
    scenario '追加ユーザーを表示する' do
      create(:user, name: '飯田洋平', admin: false)

      visit admin_users_path

      expect(page).to have_content '飯田洋平'
      expect(page).to have_content '一般ユーザー'
    end

    where(:users_count, :first_max_page, :last_max_page) do
      1   | 0 | nil
      20  | 0 | nil
      21  | 2 |   2
      100 | 3 |   5
    end

    with_them do
      scenario '1ページずつ閲覧する' do
        (users_count - 1).times do
          create(:user)
        end

        visit admin_users_path

        expect(all('li').map(&:text).map(&:to_i).max).to eq first_max_page

        if first_max_page > 0
          click_on '最後'
          expect(all('li').map(&:text).map(&:to_i).max).to eq last_max_page
        end
      end
    end
  end

  feature 'ユーザー登録' do
    scenario '新規ユーザーを登録する' do
      click_on '新規ユーザー'
      fill_in '氏名', with: '諸橋謙也'
      fill_in 'Eメールアドレス', with: 'morohasi@mail.com'
      fill_in 'パスワード',	with: 'double-check'
      fill_in '確認パスワード',	with: 'double-check'

      first(:css, '.btn-primary').click
      expect(page).to have_content '諸橋謙也'
    end
  end

  feature 'ユーザー情報更新' do
    scenario 'ユーザー情報を更新する' do
      first(:link, '編集').click
      fill_in '氏名', with: '吉岡健一'
      fill_in 'Eメールアドレス', with: 'yoshioka@mail.com'
      fill_in 'パスワード',	with: 'llllll'
      fill_in '確認パスワード',	with: 'llllll'

      first(:css, '.btn-block').click
      expect(page).to have_content '吉岡健一'
    end
  end

  feature 'ユーザー詳細情報' do
    scenario 'ユーザー詳細情報を閲覧する' do
      first(:link, '詳細').click

      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_content task.name
      expect(page).to have_content task.description
    end
  end
end
