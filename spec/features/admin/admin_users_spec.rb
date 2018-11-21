require 'rails_helper'

RSpec.feature 'Administration', type: :feature do
  using RSpec::Parameterized::TableSyntax

  let!(:user) { create(:user, :admin) }
  let!(:task) { create(:task, user: user) }

  before do
    visit root_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Enter'

    visit admin_users_path
  end

  feature 'User list' do
    scenario 'lists users' do
      another_user = create(:user, :another_user)

      visit admin_users_path

      expect(page).to have_content user.name
      expect(page).to have_content another_user.name
    end

    where(:users_count, :first_max_page, :last_max_page) do
      1   | 0 | nil
      20  | 0 | nil
      21  | 2 |   2
      100 | 3 |   5
    end

    with_them do
      scenario 'browses page by page' do
        (users_count - 1).times do
          create(:user, :unique)
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

  feature 'User creation' do
    scenario 'creates a new user' do
      click_on '新規ユーザー'
      fill_in '名前', with: '諸橋謙也'
      fill_in 'Eメールアドレス', with: 'morohasi@mail.com'
      fill_in 'パスワード',	with: 'double-check'
      fill_in '確認パスワード',	with: 'double-check'

      first(:css, '.btn-primary').click
      expect(page).to have_content '諸橋謙也'
    end
  end

  feature 'User update' do
    scenario 'update a user' do
      first(:link, '編集').click

      fill_in '名前', with: '吉岡健一'
      fill_in 'Eメールアドレス', with: 'yoshioka@mail.com'
      fill_in 'パスワード',	with: 'llllll'
      fill_in '確認パスワード',	with: 'llllll'

      first(:css, '.btn-block').click
      expect(page).to have_content '吉岡健一'
    end
  end

  feature 'User detail information' do
    scenario 'shows user detail information' do
      first(:link, '詳細').click

      expect(page).to have_content user.name
      expect(page).to have_content user.email
      expect(page).to have_content task.name
      expect(page).to have_content task.description
    end
  end
end
