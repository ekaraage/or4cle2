<!--

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

-->

# 開発環境構築(Windows11)

## 前準備

### WSL2 のインストール

Windows のコマンドプロンプトで以下を実行してバージョンが表示されていれば OK

```
wsl --version
```

[参考記事](https://qiita.com/SAITO_Keita/items/148f794a5b358e5cb87b)

！以下、コマンドは全て WSL 上で実行します！

### Docker 環境構築

[公式のドキュメント](https://docs.docker.com/engine/install/ubuntu/#install-using-the-repository) を参考に、Docker Engine をインストール

以下のコマンドも実行しておくと、docker コマンドに sudo が不要になる

```
sudo usermod -aG docker $USER
```

**【バージョン確認】**

```
docker --version
```

**【動作確認】**

```
docker run hello-world
```

## Clone

or4cle2 を置きたいディレクトリに移動し、clone

```
git clone https://github.com/ekaraage/or4cle2.git
```

## 起動、停止など

コマンドはプロジェクトルートで実行してください

**【起動】**

```
docker compose up
```

バックグラウンドで起動したい場合：

```
docker compose up -d
```

debug.gem 等のデバッガを使用したい場合：

```
docker compose up -d && docker attach or4cle2-dev
```

**【停止】**

```
docker compose down
```

**【コンテナ内のシェルに入る】**

```
docker compose exec <サービス名> bash
```

現状サービス名は `app` のみ

## ページ情報(開発環境)

トップページ：http://localhost:3000/

## おまけ(docker を使いたくない人向け)

- `mise` をインストール(適宜調べてください。 macOS は `brew install mise`で、 Linux の人は `curl` などで導入できます。詳しくは [ここ](https://mise.jdx.dev/getting-started.html) から)。
- `mise install` -> `bundle install` で必要なもの全部入ります。前者は適切なバージョンの Ruby が、後者は適切なバージョンのライブラリ類が入ります。
- `rails s`でサーバーが起動します。
