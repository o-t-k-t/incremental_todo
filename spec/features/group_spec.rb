require 'rails_helper'

RSpec.feature 'グループ管理機能', type: :feature do
  using RSpec::Parameterized::TableSyntax

  let!(:user) { create(:user) }

  background do
    visit root_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Enter'

    click_on 'グループ管理'
  end

  scenario 'グループ作成' do
    click_on 'グループを作る'

    fill_in '名前',	with: 'Kotlin勉強会'
    fill_in '内容',	with: 'Kotlinについて勉強する'

    click_on '登録'

    expect(page).to have_content 'Kotlin勉強会'
    expect(page).to have_content 'Kotlinについて勉強する'

    click_on 'グループ管理'

    expect(page).to have_content 'Kotlin勉強会'
    expect(page).to have_content 'Kotlinについて勉強する'
  end

  scenario 'グループに参加' do
    create(:group, :other_users, name: 'Scala勉強会', description: 'Scalaについて勉強する')

    click_on 'グループを探す'
    click_on 'Scala勉強会'
    click_on '加入'

    expect(page).to have_content 'グループに登録されました👨‍👦‍👦'

    click_on 'グループ管理'

    expect(page).to have_content 'Scala勉強会'
    expect(page).to have_content 'Scalaについて勉強する'
  end
end
