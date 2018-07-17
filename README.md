# 競馬スコアリング _(scoring-horse-racing)_

[![Travis](https://img.shields.io/travis/u6k/scoring-horse-racing.svg)](https://travis-ci.org/u6k/scoring-horse-racing)
[![license](https://img.shields.io/github/license/u6k/scoring-horse-racing.svg)](https://github.com/u6k/scoring-horse-racing/blob/master/LICENSE)
[![GitHub tag](https://img.shields.io/github/tag/u6k/scoring-horse-racing.svg)](https://github.com/u6k/scoring-horse-racing/releases)
[![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

> 競馬をスコアリングする

## Install

Dockerを使用します。

```
$ sudo docker version
Client:
 Version:      18.03.1-ce
 API version:  1.37
 Go version:   go1.9.5
 Git commit:   9ee9f40
 Built:        Thu Apr 26 07:17:14 2018
 OS/Arch:      linux/amd64
 Experimental: false
 Orchestrator: swarm

Server:
 Engine:
  Version:      18.03.1-ce
  API version:  1.37 (minimum version 1.12)
  Go version:   go1.9.5
  Git commit:   9ee9f40
  Built:        Thu Apr 26 07:15:24 2018
  OS/Arch:      linux/amd64
  Experimental: false

$ sudo docker-compose version
docker-compose version 1.21.0, build 5920eb0
docker-py version: 3.2.1
CPython version: 3.6.5
OpenSSL version: OpenSSL 1.0.1t  3 May 2016
```

ビルド手順は、`.travis.yml`を参照してください。

起動は、`docker-compose.production.yml`を参照してください。

## Development

開発用Dockerイメージをビルドします。

```
$ docker-compose build
```

環境変数を設定するため、 `.env` を作成します。

```
$ mv .env.example .env
```

開発用Dockerコンテナを起動します。

```
$ docker-compose up -d
```

Minioのバケットを作成します。

```
$ docker-compose exec s3 mkdir /export/horse-racing
```

テストを実行します。

```
$ docker-compose exec app rails test
```

簡単に動作確認をします。

```
$ curl http://localhost:3000/okcomputer/all.json
```

外部ネットワークから確認する場合、ngrokでポートを開放します。

```
$ ngrok http 3000
```

## API

|API|URL|
|---|---|
|ヘルスチェック|/okcomputer/all.json|

## Maintainer

- [u6k - GitHub](https://github.com/u6k/)
- [u6k.Blog()](https://blog.u6k.me/)
- [u6k_yu1 | Twitter](https://twitter.com/u6k_yu1)

## Contribute

ライセンスの範囲内で、ご自由にご使用ください。

## License

[MIT License](https://github.com/u6k/scoring-horse-racing/blob/master/LICENSE)
