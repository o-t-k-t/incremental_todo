# Incremnetal TODO

[WebベースのTODO管理アプリ](https://stormy-escarpment-80503.herokuapp.com/)です。


## 使用する技術

- Ruby 2.5.3
- Ruby on Rails 5.2.1
- PostgreSQL

## 開発に必要なソフトウェア

- rbenv 1.1.1 or laer
- Bundler 1.17.0 or later
- PostgreSQL

## デプロイ・開発の流れ

下図に示すように、当GitHub Repository上で開発を行います。
通常のGitHub FlowにCircle CIでのテストを加えた形で承認レビューを行い、マージ後、Web HookによりHerokuに自動デプロイされます。

```
GitHub
|
| 1-Clone
↓
local repos.                    　　　　　　         GitHub           Circle CI                 GitHub                             Heroku
master branch - (your change) -> feature branch -> feature branch - (Test, Static Analyze) -> (Pull Request Review) -> master -> master -> Produnction Environment
                  ↑                                                                 |                          |
                  ---------------------------------------------------------------------------------------------
```

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

### TaskLabel

|カラム|型|
|:--|:--|
|id|integer|
|task_id|integer|
|label_id|integer|
