# 競馬情報クローラー _(investment-horse-racing-crawler)_

[![Build Status](https://travis-ci.org/u6k/investment-horse-racing-crawler.svg?branch=master)](https://travis-ci.org/u6k/investment-horse-racing-crawler) [![license](https://img.shields.io/github/license/u6k/investment-horse-racing-crawler.svg)](https://github.com/u6k/investment-horse-racing-crawler/blob/master/LICENSE) [![GitHub release](https://img.shields.io/github/release/u6k/investment-horse-racing-crawler.svg)](https://github.com/u6k/investment-horse-racing-crawler/releases) [![WebSite](https://img.shields.io/website-up-down-green-red/https/shields.io.svg?label=u6k.Redmine)](https://redmine.u6k.me/projects/investment-horse-racing-crawler) [![WebSite](https://img.shields.io/website-up-down-green-red/https/shields.io.svg?label=API reference)](https://u6k.github.io/investment-horse-racing-crawler/) [![standard-readme compliant](https://img.shields.io/badge/readme%20style-standard-brightgreen.svg?style=flat-square)](https://github.com/RichardLitt/standard-readme)

> 競馬投資に使用するデータを収集する

__Table of Contents__

- [Install](#Install)
- [Usage](#Usage)
- [Other](#Other)
- [API](#API)
- [Maintainer](#Maintainer)
- [Contributing](#Contributing)
- [License](#License)

## Install

Dockerを使用します。

```
$ docker version
Client:
 Version:           18.09.5
 API version:       1.39
 Go version:        go1.10.8
 Git commit:        e8ff056dbc
 Built:             Thu Apr 11 04:44:28 2019
 OS/Arch:           linux/amd64
 Experimental:      false

Server: Docker Engine - Community
 Engine:
  Version:          18.09.5
  API version:      1.39 (minimum version 1.12)
  Go version:       go1.10.8
  Git commit:       e8ff056
  Built:            Thu Apr 11 04:10:53 2019
  OS/Arch:          linux/amd64
  Experimental:     false
```

`docker pull`します。

```
docker pull u6kapps/investment-horse-racing-crawler
```

## Usage

```
$ docker run u6kapps/investment-horse-racing-crawler help
Commands:
  investment-horse-racing-crawler crawl           # Crawl
  investment-horse-racing-crawler help [COMMAND]  # Describe available comman...
  investment-horse-racing-crawler version         # Display version
```

## Other

最新の情報は、[Wiki - investment-horse-racing-crawler - u6k.Redmine](https://redmine.u6k.me/projects/investment-horse-racing-crawler/wiki/Wiki)を参照してください。

## API

[APIリファレンス](https://u6k.github.io/investment-horse-racing-crawler/) を参照してください。

## Maintainer

- u6k
    - [Twitter](https://twitter.com/u6k_yu1)
    - [GitHub](https://github.com/u6k)
    - [Blog](https://blog.u6k.me/)

## Contributing

当プロジェクトに興味を持っていただき、ありがとうございます。[既存のチケット](https://redmine.u6k.me/projects/investment-horse-racing-crawler//issues/)をご覧ください。

当プロジェクトは、[Contributor Covenant](https://www.contributor-covenant.org/version/1/4/code-of-conduct)に準拠します。

## License

[MIT License](https://github.com/u6k/investment-horse-racing-crawler/blob/master/LICENSE)

