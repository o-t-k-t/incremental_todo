require 'rails_helper'

RSpec.feature 'Task managemant', type: :feature do
  background do
    create(:task, :homework)
    create(:task, :shopping)
  end

  scenario 'view task list' do
    visit root_path

    expect(page).to have_content 'Wirte a paper'
    expect(page).to have_content 'Do something'
    expect(page).to have_content 'Buy a bread'
    expect(page).to have_content 'Do something'
  end

  scenario 'show task detail' do
    visit root_path

    all('tbody tr')[0].click_link 'Show'

    expect(page).to have_content 'Wirte a paper'
    expect(page).to have_content 'Do something'
  end

  scenario 'create a task' do
    visit root_path
    click_link 'New Task'

    fill_in 'Name',	with: 'New task'
    fill_in 'Description',	with: 'Do the newest thing'
    click_on 'Create'

    expect(page).to have_selector '.notice', text: 'A task successfully created🎉'

    expect(page).to have_content 'New task'
    expect(page).to have_content 'Do the newest thing'
  end
end
