# メモアプリ (Sinatra)
これはSinatraで作成したシンプルなメモアプリです。

## 実行環境
* Ruby 3.0.0 以上
* Bundler

## 実行手順 (ローカル)
1.  **リポジトリをクローン**
    ```bash
    git clone https://github.com/yuumizoi/memo-app.git
    cd memo-app
    ```

2.  **Gemのインストール**
    (開発用の `rubocop` や `erb_lint` も含めてインストールされます)
    ```bash
    bundle install
    ```

3.  **Webサーバーの起動**
    ```bash
    bundle exec rackup
    ```

4.  **ブラウザでアクセス**
    Webサーバーが起動したら、ブラウザで以下のURLにアクセスしてください。
    [http://localhost:9292/memos](http://localhost:9292/memos)

## アプリケーションの停止
ターミナルで `Ctrl + C` を押すとサーバーが停止します。

## コードチェックの実行方法
### RuboCop (Rubyコードのチェック)

```bash
bundle exec rubocop
```

### ERB Lint (ERBファイルのチェック)

```
bundle exec erb_lint views/*.erb
```
