# Incremnetal TODO

[![ruby version](https://img.shields.io/badge/Ruby-v2.5.1-green.svg)](https://www.ruby-lang.org/ja/)
[![rails version](https://img.shields.io/badge/Rails-v5.1.6-brightgreen.svg)](http://rubyonrails.org/)
[![CircleCI](https://circleci.com/gh/o-t-k-t/incremental_todo.svg?style=svg)](https://circleci.com/gh/o-t-k-t/incremental_todo)
[![Maintainability](https://api.codeclimate.com/v1/badges/5105da6d038478844821/maintainability)](https://codeclimate.com/github/o-t-k-t/incremental_todo/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/5105da6d038478844821/test_coverage)](https://codeclimate.com/github/o-t-k-t/incremental_todo/test_coverage)

株式会社万葉様教育カリキュラムベースの[タスク管理アプリ](https://incremental-todo.herokuapp.com/)です。

## 使用する技術

- Ruby 2.5.3
- Ruby on Rails 5.2.1
- PostgreSQL
- Redis 5.0.2

## 開発に必要なソフトウェア

- rbenv 1.1.1 or laer
- Bundler 1.17.0 or later
- PostgreSQL
- Redis 5.0.2

## デプロイ・開発の流れ

下図に示すように、当GitHub Repository上で開発を行います。
通常のGitHub FlowにCircle CIでのテストを加えた形で承認レビューを行い、マージ後、Web HookによりHerokuに自動デプロイされます。

```
GitHub
|
| Clone
↓
local repos.                    　　　　　　         GitHub           Circle CI                 GitHub                             Heroku
master branch - (your change) -> feature branch -> feature branch - (Test, Static Analyze) -> (Pull Request Review) -> master -> master -> Produnction Environment
                  ↑                                                                 |                          |
                  ---------------------------------------------------------------------------------------------
```

## ローカル環境での起動方法
このリポジトリをローカルの任意のディレクトリにクローン。

```
git clone git@github.com:o-t-k-t/incremental_todo.git
```

リポジトリの作業ディレクトリに移動し、Gemをインストール。

```
cd incremental_todo
bundle install
```

クローンされたディレクトリ　直下に`.env`というファイルを作成し下記フォーマットで初期管理ユーザー情報の環境変数を設定。

```
FISRT_ADMIN_EMAIL="【任意の管理ユーザーEメールアドレス】"
FISRT_ADMIN_PASSWORD="【任意の管理ユーザーログインパスワード】"
```

データベース作成・初期化

```
bundle exec rails db: create
bundle exec rails db: migrate
bundle exec rails db: seed
```

別ターミナルを開き、Redisサーバを起動

```
redis-server /usr/local/etc/redis.conf
```

webサーバを起動

```
bundle exec rails s
```

[localhost:3000](http://localhost:3000)から当アプリに接続できます。

## 管理画面へのアクセス

[localhost:3000/admin](http://localhost:3000/admin)から管理画面にアクセスできます。
シードデータ作成時に環境変数`FISRT_ADMIN_EMAIL`,
`FISRT_ADMIN_PASSWORD`に設定したEメール・パスワードでログインできます。

## テーブルとスキーマ

### Task

|カラム|型|
|:--|:--|
|id|integer|
|user_id|integer|
|name|string|
|description|text|
|priority|integer|
|deadline|date|
|status|integer|

### User

|カラム|型|
|:--|:--|
|id|integer|
|name|string|
|email|string|
|password_digest|string|
|admin|boolean|

### Label

|カラム|型|
|:--|:--|
|id|integer|
|user_id|integer|
|name|string|
|description|text|
|color|integer|

### TaskLabel

|カラム|型|
|:--|:--|
|id|integer|
|task_id|integer|
|label_id|integer|

### Group

|カラム|型|
|:--|:--|
|id|integer|
|name|string|
|description|text|

### Membership

|カラム|型|
|:--|:--|
|id|integer|
|user_id|integer|
|group_id|integer|
|role|integer|
