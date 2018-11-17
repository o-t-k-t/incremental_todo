require 'rails_helper'

RSpec.feature 'Administration', type: :feature do
  using RSpec::Parameterized::TableSyntax

  let!(:user) { create(:user) }
  let!(:another_user) { create(:user, :another_user) }
  let!(:task) { create(:task, user: user) }

  before do
    visit admin_users_path
  end

  feature 'User list' do
    scenario 'lists users' do
      expect(page).to have_content user.name
      expect(page).to have_content another_user.name
    end
  end

  feature 'User creation' do
    before do
      click_on 'ユーザ登録'
      fill_in '名前', with: '諸橋謙也'
      fill_in 'Eメールアドレス', with: 'morohasi@mail.com'
      fill_in 'パスワード',	with: 'double-check'
      fill_in '確認パスワード',	with: 'double-check'
    end

    scenario 'creates a new user' do
      click_on 'submit-btn'
      expect(page).to have_content '諸橋謙也'
    end
  end

  feature 'User update' do
    before do
      first(:link, '編集').click
      fill_in '名前', with: '吉岡健一'
      fill_in 'Eメールアドレス', with: 'yoshioka@mail.com'
      fill_in 'パスワード',	with: 'llllll'
      fill_in '確認パスワード',	with: 'llllll'
    end

    scenario 'update a user' do
      first(:css, '.btn').click
      expect(page).to have_content '吉岡健一'
      expect(page).to have_content 'yoshioka@mail.com'
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
