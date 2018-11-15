require 'rails_helper'

RSpec.feature 'Task managemant', type: :feature do
  around do |ex|
    user = create(:user)
    travel_to(DateTime.new(2018, 11, 4, 13, 14, 15)) { create(:task, :homework_by_12, user: user) }
    travel_to(DateTime.new(2018, 11, 5, 13, 14, 15)) { create(:task, :shopping_by_13, user: user) }
    travel_to(DateTime.new(2018, 11, 6, 13, 14, 15)) { create(:task, :cleanup, user: user) }

    travel_to(DateTime.new(2018, 11, 12, 13, 15, 30)) do
      visit root_path

      fill_in 'Email', with: 'hiramatsu.takashi1972@example.com'
      fill_in 'Password', with: 'ca11back'
      click_on 'Enter'

      visit root_path
      ex.run
    end
  end

  scenario 'view task list that sorted by newness' do
    expect(all('.card-title')[0]).to have_content '掃除する'
    expect(all('.card-text')[0]).to have_content '何かする'
    expect(all('.card-title')[1]).to have_content 'パンを買う'
    expect(all('.card-text')[1]).to have_content '何かする'
    expect(all('.card-title')[2]).to have_content '論文を書く'
    expect(all('.card-text')[2]).to have_content '何かする'
  end

  scenario 'view task list that sorted by deadline' do
    select '期限', from: '順序'
    click_on '並び替え'

    expect(all('.card-title')[0]).to have_content '論文を書く'
    expect(all('.card-text')[0]).to have_content '何かする'
    expect(all('.card-title')[1]).to have_content 'パンを買う'
    expect(all('.card-text')[1]).to have_content '何かする'
    expect(all('.card-title')[2]).to have_content '掃除する'
    expect(all('.card-text')[2]).to have_content '何かする'
  end

  scenario 'view task list that sorted by deadline' do
    select '優先度', from: '順序'
    click_on '並び替え'

    expect(all('.card-title')[0]).to have_content '論文を書く'
    expect(all('.card-text')[0]).to have_content '何かする'
    expect(all('.card-title')[1]).to have_content '掃除する'
    expect(all('.card-text')[1]).to have_content '何かする'
    expect(all('.card-title')[2]).to have_content 'パンを買う'
    expect(all('.card-text')[2]).to have_content '何かする'
  end

  scenario 'show task detail' do
    all('.card')[0].click_link '詳細'

    expect(page).to have_content '掃除する'
    expect(page).to have_content '何かする'
    expect(page).to have_content '期限なし'
    expect(page).to have_content '中'
  end

  scenario 'execute typical task life cycle' do
    click_link '新規作成'

    fill_in '名前',	with: '続けるタスク'
    fill_in '内容',	with: '何かする'
    fill_in '期限', with: '2018/11/20T20:15'
    select '高', from: '優先度'
    click_on '登録'

    expect(page).to have_selector '.notice', text: 'タスクが新しく登録されました🎉'

    expect(all('.card-title')[0]).to have_content '続けるタスク'
    expect(all('.card-text')[0]).to have_content '何かする'
    expect(all('.card-subtitle')[0]).to have_content '未着手'
    expect(all('.card-subtitle')[0]).to have_content '〜2018/11/20 20:15'

    check '未着手'
    click_on '検索'

    expect(all('.card-title')[0]).to have_content '続けるタスク'

    all('.card')[0].click_link '編集'

    select '作業開始', from: '進捗はありましたか？'
    select '中', from: '優先度'
    click_on '登録'

    expect(page).to have_selector '.notice', text: 'タスクが更新されました👍'
    expect(all('.card-title')[0]).to have_content '続けるタスク'
    expect(all('.card-subtitle')[0]).to have_content '着手中'
    expect(all('.card-subtitle')[0]).to have_content '中'

    check '着手中'
    click_on '検索'

    expect(all('.card-title')[0]).to have_content '続けるタスク'

    all('.card')[0].click_link '編集'
    select 'なし', from: '進捗はありましたか？'
    select '低', from: '優先度'
    click_on '登録'

    expect(page).to have_selector '.notice', text: 'タスクが更新されました👍'
    expect(all('.card-subtitle')[0]).to have_content '着手中'
    expect(all('.card-subtitle')[0]).to have_content '低'

    all('.card')[0].click_link '編集'
    select '作業完了', from: '進捗はありましたか？'
    click_on '登録'

    expect(page).to have_selector '.notice', text: 'タスクが更新されました👍'
    expect(all('.card-title')[0]).to have_content '続けるタスク'
    expect(all('.card-subtitle')[0]).to have_content '完了'

    check '完了済み'
    click_on '検索'

    expect(all('.card-title')[0]).to have_content '続けるタスク'
  end

  scenario 'create a indefinite task' do
    click_link '新規作成'

    fill_in '名前',	with: '無期限タスク'
    fill_in '内容',	with: 'いつか何かする'

    click_on '登録'

    expect(page).to have_selector '.notice', text: 'タスクが新しく登録されました🎉'

    expect(all('.card-title')[0]).to have_content '無期限タスク'
    expect(all('.card-text')[0]).to have_content 'いつか何かする'
    expect(all('.card-subtitle')[0]).to have_content '期限なし'
  end

  scenario 'editting a task to no name is rejected' do
    all('.card')[0].click_link '編集'

    fill_in '名前',	with: ''
    fill_in '内容',	with: ''
    click_on '登録'

    expect(page).to have_selector '.notice', text: '申し訳ありません、タスクは更新できませんでした😫'
    expect(page).to have_content '1件のエラーがあります。'
    expect(page).to have_content '名前を入力してください'
  end

  scenario 'search by name' do
    fill_in '名前',	with: 'パンを買う'
    click_on '検索'

    expect(page).to have_content 'パンを買う'
    expect(page).not_to have_content '掃除する'
    expect(page).not_to have_content '論文を書く'
  end

  scenario 'search by status' do
    check 'q_status_eq_any_not_started'
    click_on '検索'

    expect(page).to have_content 'パンを買う'
    expect(page).to have_content '掃除する'
    expect(page).to have_content '論文を書く'
  end
end
