require 'rails_helper'

RSpec.feature 'タスク管理機能', type: :feature do
  let!(:user) { create(:user) }

  before do
    visit root_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Enter'
  end

  feature 'ルートページ' do
    before do
      base_time = Time.zone.local(2018, 11, 4, 13, 14, 15)

      travel_to(base_time) { create(:task, name: '論文', description: '論文を書く', user: user) }
      travel_to(base_time + 1.days) { create(:task, name: '買い物', description: 'パンを買う', user: user) }
      travel_to(base_time + 2.days) { create(:task, name: '掃除', description: '床の拭き掃除', user: user) }
    end

    scenario '登録日が新しい順にタスクを表示する' do
      visit root_path

      expect(all('.card-title')[0]).to have_content '掃除'
      expect(all('.card-text')[0]).to have_content '床の拭き掃除'
      expect(all('.card-title')[1]).to have_content '買い物'
      expect(all('.card-text')[1]).to have_content 'パンを買う'
      expect(all('.card-title')[2]).to have_content '論文'
      expect(all('.card-text')[2]).to have_content '論文を書く'
    end
  end

  feature '期限順並び替えボタン' do
    before do
      base_time = Time.zone.local(2018, 11, 12, 13, 14, 15)

      travel_to(base_time) do
        create(:task, name: '論文', deadline: base_time + 1.day, user: user)
        create(:task, name: '買い物', deadline: base_time + 2.day, user: user)
        create(:task, name: '掃除', deadline: base_time + 3.days, user: user)
        create(:task, name: '申請', user: user)
      end

      visit root_path
    end

    scenario '期限が近い順にタスクを表示する' do
      select '期限', from: '順序'
      click_on '並び替え'

      expect(all('.card-title')[0]).to have_content '論文'
      expect(all('.card-title')[1]).to have_content '買い物'
      expect(all('.card-title')[2]).to have_content '掃除'
      expect(all('.card-title')[3]).to have_content '申請'
    end
  end

  feature '優先順位並び替えボタン' do
    before do
      create(:task, name: '論文', priority: 1, user: user)
      create(:task, name: '買い物',  priority: 2, user: user)
      create(:task, name: '掃除',  priority: 3, user: user)

      visit root_path
    end

    scenario 'view task list that sorted by deadline' do
      select '優先度', from: '順序'
      click_on '並び替え'

      expect(all('.card-title')[0]).to have_content '掃除'
      expect(all('.card-title')[1]).to have_content '買い物'
      expect(all('.card-title')[2]).to have_content '論文'
    end
  end

  feature 'タスク詳細' do
    before do
      create(:task, name: '論文', description: '論文を書く', priority: 2, user: user)

      visit root_path
    end

    scenario '対象タスクの各情報を表示する' do
      all('.card')[0].click_link '詳細'

      expect(page).to have_content '論文'
      expect(page).to have_content '論文を書く'
      expect(page).to have_content '期限なし'
      expect(page).to have_content '中'
    end
  end

  feature 'タスク新規作成' do
    before do
      visit root_path
    end

    scenario 'タスクを進捗状態の入力により作業完了まで登録' do
      click_link '新規作成'

      fill_in '名前',	with: '続けるタスク'
      fill_in '内容',	with: '何かする'
      select '高', from: '優先度'
      click_on '登録'

      expect(page).to have_selector '.notice', text: 'タスクが新しく登録されました🎉'

      expect(all('.card-title')[0]).to have_content '続けるタスク'
      expect(all('.card-text')[0]).to have_content '何かする'
      expect(all('.card-subtitle')[0]).to have_content '未着手'

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

    scenario '無期限タスクを登録できる' do
      click_link '新規作成'

      fill_in '名前',	with: '無期限タスク'
      fill_in '内容',	with: 'いつか何かする'

      click_on '登録'

      expect(page).to have_selector '.notice', text: 'タスクが新しく登録されました🎉'

      expect(all('.card-title')[0]).to have_content '無期限タスク'
      expect(all('.card-text')[0]).to have_content 'いつか何かする'
      expect(all('.card-subtitle')[0]).to have_content '期限なし'
    end
  end

  feature 'タスク編集' do
    before do
      create(:task, name: '論文', description: '論文を書く', priority: 2, user: user)

      visit root_path
    end

    scenario 'タスク登録を編集する' do
      all('.card')[0].click_link '編集'

      fill_in '名前',	with: '更新タスク'
      fill_in '内容',	with: '更新した内容で何かする'
      click_on '登録'

      expect(all('.card-title')[0]).to have_content '更新タスク'
      expect(all('.card-text')[0]).to have_content '更新した内容で何かする'
      expect(all('.card-subtitle')[0]).to have_content '期限なし'
    end

    scenario '名前が未入力のタスク登録が失敗する' do
      all('.card')[0].click_link '編集'

      fill_in '名前',	with: ''
      fill_in '内容',	with: ''
      click_on '登録'

      expect(page).to have_selector '.notice', text: '申し訳ありません、タスクは更新できませんでした😫'
      expect(page).to have_content '1件のエラーがあります。'
      expect(page).to have_content '名前を入力してください'
    end
  end

  feature 'タスク検索' do
    before do
      base_time = Time.zone.local(2018, 11, 4, 13, 14, 15)

      travel_to(base_time) { create(:task, name: 'パンを買う', priority: 3, user: user) }
      travel_to(base_time + 1.days) { create(:task, name: '掃除する', priority: 2, user: user) }
      travel_to(base_time + 2.days) { create(:task, name: '論文を書く', priority: 1, user: user) }

      visit root_path
    end

    scenario '名前で検索' do
      fill_in '名前',	with: 'パンを買う'
      click_on '検索'

      expect(page).to have_content 'パンを買う'
      expect(page).not_to have_content '掃除する'
      expect(page).not_to have_content '論文を書く'
    end

    scenario '進捗状態で検索' do
      all('.card')[0].click_link '編集'

      select '作業開始', from: '進捗はありましたか？'
      click_on '登録'

      expect(page).to have_selector '.notice', text: 'タスクが更新されました👍'

      check 'q_status_eq_any_started'
      click_on '検索'

      expect(page).to have_content '論文を書く'
      expect(page).not_to have_content 'パンを買う'
      expect(page).not_to have_content '掃除する'
    end
  end
end
