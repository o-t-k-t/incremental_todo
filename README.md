# Incremnetal TODO

[![ruby version](https://img.shields.io/badge/Ruby-v2.5.3-green.svg)](https://www.ruby-lang.org/ja/)
[![rails version](https://img.shields.io/badge/Rails-v5.2.1-brightgreen.svg)](http://rubyonrails.org/)
[![CircleCI](https://circleci.com/gh/o-t-k-t/incremental_todo.svg?style=svg)](https://circleci.com/gh/o-t-k-t/incremental_todo)
[![Maintainability](https://api.codeclimate.com/v1/badges/5105da6d038478844821/maintainability)](https://codeclimate.com/github/o-t-k-t/incremental_todo/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/5105da6d038478844821/test_coverage)](https://codeclimate.com/github/o-t-k-t/incremental_todo/test_coverage)

株式会社万葉様教育カリキュラムベースの[タスク管理アプリ](https://incremental-todo.herokuapp.com/)です。

## 機能

- ユーザーとして登録すると、自分のタスクを簡単に登録できる
- タスクには以下を設定できる
  - 終了期限を設定
  - 優先順位
  - ステータス（未着手・着手・完了）
  - 複数の添付ファイル
- タスクを一覧できる
  - 優先順位、終了期限などを元にしてソートできる
-タスクの絞り込み
  - ステータス
　- タスク名
- タスクにラベルなどをつけて分類できる
- タスクアラート機能
  - 期限が残り3日を過ぎたタスクがあると、画面上で通知する
- ユーザーグループ機能
  - グループ作成
  - グループ情報の編集や削除はそのグループの作成者のみができる
  - 複数のグループにユーザーは自由に参加・離脱できる
  - グループの作成者は、グループを離脱もできない
  - グループの参加者はグループ詳細画面に入れ、そのグループのユーザーたちのタスクを参照できる
- ユーザー登録時、プロフィール画像を登録できる
- 管理機能を持つ
  - ユーザーの新規登録・削除・編集
  - ユーザーへの管理者権限への付与・削除
  - 初期状態で1名の管理者を登録できる

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
bundle install --path vendor/bundle
```

クローンされたディレクトリ　直下に`.env`というファイルを作成し下記フォーマットで初期管理ユーザー情報の環境変数を設定。

```
FISRT_ADMIN_EMAIL="【任意の管理ユーザーEメールアドレス】"
FISRT_ADMIN_PASSWORD="【任意の管理ユーザーログインパスワード】"
REDIS_URL="redis:localhost:6379"
```

データベース作成・初期化

```
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed
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
