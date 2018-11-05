require 'rails_helper'

RSpec.feature 'Task managemant', type: :feature do
  background do
    create(:task, :homework)
    create(:task, :shopping)
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

  scenario 'show task detail' do
    tasks[0].click_link '詳細'

    expect(page).to have_content '掃除する'
    expect(page).to have_content '何かする'
  end

  scenario 'create a task' do
    visit root_path
    click_link '作成'

    fill_in '名前',	with: '新しいタスク'
    fill_in '内容',	with: '何かする'
    click_on '作成'

    expect(page).to have_selector '.notice', text: 'タスクが新しく登録されました🎉'

    expect(tasks[0]).to have_content '新しいタスク'
    expect(tasks[0]).to have_content '何かする'
  end
end
