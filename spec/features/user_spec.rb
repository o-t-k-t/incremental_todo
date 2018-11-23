require 'rails_helper'

RSpec.feature 'User session managemant', type: :feature do
  using RSpec::Parameterized::TableSyntax

  around do |ex|
    create(:user,
           name: '平松隆',
           email: 'hiramatsu.takashi1972@example.com',
           admin: false,
           password: 'ca11back',
           password_confirmation: 'ca11back')

    travel_to(Time.zone.local(2018, 11, 12, 13, 15, 30)) do
      visit root_path
      ex.run
    end
  end

  scenario 'ログイン・ログアウト' do
    fill_in 'Email', with: 'hiramatsu.takashi1972@example.com'
    fill_in 'Password', with: 'ca11back'
    click_on 'Enter'

    expect(page).to have_content '平松隆さんとしてログインしました😃'
    expect(page).to have_content 'あなたのページ'
    expect(page).to have_content '平松隆'
    expect(page).to have_content 'hiramatsu.takashi1972@example.com'

    click_on 'ログアウト'

    expect(all('h1')[0]).to have_content 'ログイン'
  end

  scenario '誤ったパスワード入力時、ログインに失敗する' do
    fill_in 'Email', with: 'hiramatsu.takashi1972@example.com'
    fill_in 'Password', with: 'proce55ing'
    click_on 'Enter'

    expect(all('h1')[0]).to have_content 'ログイン'
    expect(page).to have_content 'Eメールアドレスかパスワードが不正です'
  end

  where(:path, :page_title) do
    root_path         | 'ログイン'
    tasks_path        | 'ログイン'
    new_task_path(1)  | 'ログイン'
    edit_task_path(1) | 'ログイン'
    task_path(1)      | 'ログイン'
    user_path         | 'ログイン'
  end

  with_them do
    scenario 'when loged out' do
      visit path
      expect(all('h1')[0]).to have_content page_title
    end
  end
end
