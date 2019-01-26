# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- [#6740: CLIアプリに変更する](https://redmine.u6k.me/issues/6740)
  - Railsアプリケーションとして実装していましたが、常駐プロセスにするする意味はないので、gemによるCLIアプリケーションに変更しました
- [#6735: 共通処理をcrawlineに切り出して、crawlineベースで再実装する](https://redmine.u6k.me/issues/6735)
  - クローラーごとに少しずつ異なる処理を実装していましたが、それらをcrawlineに集約して、crawlineをベースに再実装しました
