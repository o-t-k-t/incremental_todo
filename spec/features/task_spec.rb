require 'rails_helper'

RSpec.feature 'Task managemant', type: :feature do
  background do
    create(:task, :homework_by_12)
    create(:task, :shopping_by_13)
    create(:task, :cleanup)

    visit root_path
  end

  let(:tasks) { page.all('tbody tr') }

  scenario 'view task list that sorted by newness' do
    expect(tasks[0]).to have_content '掃除する'
    expect(tasks[0]).to have_content '何かする'
    expect(tasks[1]).to have_content 'パンを買う'
    expect(tasks[1]).to have_content '何かする'
    expect(tasks[2]).to have_content '論文を書く'
    expect(tasks[2]).to have_content '何かする'
  end

  scenario 'view task list that sorted by deadline' do
    select '期限', from: '順序'
    click_on '並び替え'

    expect(tasks[0]).to have_content '論文を書く'
    expect(tasks[0]).to have_content '何かする'
    expect(tasks[1]).to have_content 'パンを買う'
    expect(tasks[1]).to have_content '何かする'
    expect(tasks[2]).to have_content '掃除する'
    expect(tasks[2]).to have_content '何かする'
  end

  scenario 'show task detail' do
    tasks[0].click_link '詳細'

    expect(page).to have_content '掃除する'
    expect(page).to have_content '何かする'
    expect(page).to have_content '期限なし'
  end

  scenario 'execute typical task life cycle' do
    travel_to(DateTime.new(2018, 11, 12, 13, 15, 30)) do
      click_link '新規作成'

      fill_in '名前',	with: '続けるタスク'
      fill_in '内容',	with: '何かする'
      fill_in '期限', with: '2018/11/20T20:15'

      click_on '登録'

      expect(page).to have_selector '.notice', text: 'タスクが新しく登録されました🎉'

      expect(page.all('tbody tr')[0]).to have_content '続けるタスク'
      expect(page.all('tbody tr')[0]).to have_content '何かする'
      expect(page.all('tbody tr')[0]).to have_content '未着手'
      expect(page.all('tbody tr')[0]).to have_content '2018/11/20 20:15'

      page.all('tbody tr')[0].click_link '編集'

      expect(page).to have_content '未着手'

      select '作業開始', from: '進捗はありましたか？'
      click_on '登録'

      expect(page).to have_selector '.notice', text: 'タスクが更新されました👍'
      expect(page).to have_content '着手中'

      page.all('tbody tr')[0].click_link '編集'
      select 'なし', from: '進捗はありましたか？'
      click_on '登録'

      expect(page).to have_selector '.notice', text: 'タスクが更新されました👍'
      expect(page).to have_content '着手中'

      page.all('tbody tr')[0].click_link '編集'
      select '作業完了', from: '進捗はありましたか？'
      click_on '登録'

      expect(page).to have_selector '.notice', text: 'タスクが更新されました👍'
      expect(page).to have_content '完了'
    end
  end

  scenario 'create a indefinite task' do
    travel_to(DateTime.new(2018, 11, 12, 13, 15, 30)) do
      click_link '新規作成'

      fill_in '名前',	with: '無期限タスク'
      fill_in '内容',	with: 'いつか何かする'

      click_on '登録'

      expect(page).to have_selector '.notice', text: 'タスクが新しく登録されました🎉'

      expect(tasks[0]).to have_content '無期限タスク'
      expect(tasks[0]).to have_content 'いつか何かする'
      expect(tasks[0]).to have_content '期限なし'
    end
  end

  scenario 'editting a task to no name is rejected' do
    tasks[0].click_link '編集'

    fill_in '名前',	with: ''
    fill_in '内容',	with: ''
    click_on '登録'

    expect(page).to have_selector '.notice', text: '申し訳ありません、タスクは更新できませんでした😫'
    expect(page).to have_content '1件のエラーがあります。'
    expect(page).to have_content '名前を入力してください'
  end
end
