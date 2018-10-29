# README

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
|name|string|
|description|text|

### TaskLabel

|カラム|型|
|:--|:--|
|id|integer|
|task_id|integer|
|label_id|integer|

### UserLabel

|カラム|型|
|:--|:--|
|id|integer|
|user_id|integer|
|label_id|integer|
