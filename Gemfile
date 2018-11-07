source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

ruby '2.5.3'
gem 'rails', '~> 5.2.1'

# ミドルウェア
gem 'pg', '~> 0.18'
gem 'puma', '~> 3.7'

# 画像アップロード
gem 'carrierwave'
gem 'mini_magick'

# フロントエンド
gem 'bulma-rails', '~> 0.4.2'
gem 'coffee-rails', '~> 4.2'
gem 'haml-rails'
gem 'sass-rails', '~> 5.0'
gem 'turbolinks', '~> 5'
gem 'uglifier', '>= 1.3.0'
gem 'draper'

# 認証
gem 'bcrypt', '~> 3.1.11'
gem 'bootsnap', '>= 1.1.0'
gem 'cancancan'
gem 'devise'
gem 'rails_admin', '~> 1.3'

gem 'faker'

# 日付処理
gem 'validates_timeliness'

group :development, :test do
  # デバッグ
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'pry-rails'
  gem 'spring'

  # 静的解析
  gem 'brakeman'
  gem 'bullet'
  gem 'haml_lint'
  gem 'rubocop', '~> 0.59.2'
  gem 'rubycritic'
  gem 'simplecov'

  # テスト
  gem 'capybara', '~> 2.13'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'flay', '~> 2.10.0'
  gem 'launchy'
  gem 'rspec-parameterized'
  gem 'rspec-rails'
  gem 'rspec_junit_formatter'
  gem 'selenium-webdriver'
  gem 'spring-commands-rspec'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '~> 2.0'

  # ローカルEメールテスト
  gem 'letter_opener_web'

  # コード補完
  gem 'solargraph'

  # 環境変数アクセス
  gem 'dotenv-rails'
end

gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
