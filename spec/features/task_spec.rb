require 'rails_helper'

RSpec.feature 'Task managemant', type: :feature do
  background do
    create(:task, :homework)
    create(:task, :shopping)
  end

  scenario 'view task list' do
    visit root_path

    expect(page).to have_content '論文を書く'
    expect(page).to have_content '何かする'
    expect(page).to have_content 'パンを買う'
    expect(page).to have_content '何かする'
  end

  scenario 'show task detail' do
    visit root_path

    all('tbody tr')[0].click_link '詳細'

    expect(page).to have_content '論文を書く'
    expect(page).to have_content '何かする'
  end

  scenario 'create a task' do
    visit root_path
    click_link '作成'

    fill_in '名前',	with: '新しいタスク'
    fill_in '内容',	with: '何かする'
    click_on '作成'

    expect(page).to have_selector '.notice', text: 'タスクが新しく登録されました🎉'

    expect(page).to have_content '新しいタスク'
    expect(page).to have_content '何かする'
  end
end
