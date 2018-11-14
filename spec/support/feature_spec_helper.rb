def create_user_and_log_in
  create :user
  visit root_path
  fill_in 'Eメールアドレス', with: 'hiramatsu.takashi1972@example.com'
  fill_in :user_password, with: 'ca11back'
  click_on 'ログイン'
end
