# メモアプリ (SSinatra + PostgreSQL)
これはRubyの軽量フレームワーク Sinatra で作成したシンプルなメモアプリです。
データを保存するために PostgreSQL データベースを使用しています。

## 実行環境
- Ruby: 3.x 系 (推奨： 3.4.7 以上)
- Bundler: 2.x 系 (推奨： 2.6.2 以上)
- データベース： PostgreSQL 14.x 以上 (推奨: 18.0 以上)

## 実行手順 (ローカル)
1.  **リポジトリをクローン**
  ```bash
  git clone [https://github.com/yuumizoi/memo-app.git](https://github.com/yuumizoi/memo-app.git)
  cd memo-app
  ```

2.  **Gemのインストール**
    (PostgreSQL接続に必要な `pg` gem など、すべての依存関係をインストールします)
    ```bash
    bundle install
    ```

3. **データベースのセットアップ (PostgreSQL)**
- データベースサーバーが起動していることを確認し、以下の手順でDBを作成・テーブルを初期化します。

3-1. **データベースの作成**
- `memo_app_db` という名前でデータベースを作成します。
  ```bash
  createdb memo_app_db
  ```

3-2. **テーブルの初期化**
- DBに接続し、`memos` テーブルを作成します。
  ```bash
  psql -d memo_app_db -f schema.sql
  ```

  :::note warn
  重要
  アプリケーションはDB接続に特定のユーザー名とパスワードを使用します。
  もしサーバー起動時に認証エラーが出る場合は、`database_connection.rb` の設定を、あなたのPostgreSQL環境に合わせて修正してください。
  :::

4.  **Webサーバーの起動**
    ```bash
    bundle exec rackup
    ```

5.  **ブラウザでアクセス**
- Webサーバーが起動したら、ブラウザで以下のURLにアクセスをしてください。
  [http://localhost:9292/memos](http://localhost:9292/memos)

## アプリケーションの停止
- ターミナルで `Ctrl + C` を押すとサーバーが停止します。

## コードチェックの実行方法
### RuboCop (Rubyコードのチェック)
  ```bash
  bundle exec rubocop
  ```

### ERB Lint (ERBファイルのチェック)
  ```bash
  bundle exec erb_lint --lint-all views
  ```
