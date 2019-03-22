# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed

- [#6761: HorsePage、JockyPage、TrainerPageの再ダウンロードを、「前回ダウンロードから1ヶ月以降なら再ダウンロードする」とする](https://redmine.u6k.me/issues/6761)
- [#6854: 全ページにおいて、前回ダウンロード時刻が1日以内の場合は再ダウンロードしない、とする](https://redmine.u6k.me/issues/6854)

## [0.5.1] - 2019-03-20

### Fixed

- [#6851: crawlineの最新バージョンを適用する](https://redmine.u6k.me/issues/6851)
    - crawlコマンドを実行したところエラーになったので、対応するとともにコマンドのテストを記述しました

## [0.5.0] - 2019-03-20

### Fixed

- [#6851: crawlineの最新バージョンを適用する](https://redmine.u6k.me/issues/6851)

## [0.4.0] - 2019-03-17

### Added

- [#6841: 本番用のDockerイメージを構築する](https://redmine.u6k.me/issues/6841)

## [0.3.0] - 2019-03-11

### Added

- [#6760: トップページからすべてのページをクローリングできるようにパーサーを構築する](https://redmine.u6k.me/issues/6760)

## [0.2.0] - 2019-03-11

### Added

- [#6833: コマンドでレース・リスト・ページをクロールする](https://redmine.u6k.me/issues/6833)

## [0.1.0] - 2019-03-08

### Added

- [#6740: CLIアプリに変更する](https://redmine.u6k.me/issues/6740)
  - Railsアプリケーションとして実装していましたが、常駐プロセスにするする意味はないので、gemによるCLIアプリケーションに変更しました
- [#6735: 共通処理をcrawlineに切り出して、crawlineベースで再実装する](https://redmine.u6k.me/issues/6735)
  - クローラーごとに少しずつ異なる処理を実装していましたが、それらをcrawlineに集約して、crawlineをベースに再実装しました
- [#6829: コマンドでスケジュール・リスト・ページをクロールする](https://redmine.u6k.me/issues/6829)
