# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.1] - 2019-05-07

### Fixed

- [#7045: lib/investment_horse_racing/crawler/parser/entry_page.rb:61 - undefined method `strip' for nil:NilClass (NoMethodError)](https://redmine.u6k.me/issues/7045)
- [#7046: lib/investment_horse_racing/crawler/parser/result_page.rb:20 - can't convert nil into an exact number (TypeError)](https://redmine.u6k.me/issues/7046)

## [1.3.0] - 2019-05-02

### Changed

- [#7031: ロガーの名前をAPP_LOGGER_xxxに変更する](https://redmine.u6k.me/issues/7031)
- [#7021: 再ダウンロード判定から、最近ダウンロードしたから再ダウンロードしない、という条件を除去する](https://redmine.u6k.me/issues/7021)
- [#7036: horse、trainer、jockeyページをダウンロードしない](https://redmine.u6k.me/issues/7036)
- [#7033: パーサー・テストの前提条件設定で、WebMockで初期化する](https://redmine.u6k.me/issues/7033)
- [#7039: データ保存をバルク・インサートで行う](https://redmine.u6k.me/issues/7039)

## [1.2.0] - 2019-05-01

### Added

- [#7035: DBデータ保存時にデバッグ・ログを出力する](https://redmine.u6k.me/issues/7035)

## [1.1.0] - 2019-04-30

### Added

- [#6839: レース情報をDBに格納する](https://redmine.u6k.me/issues/6839)

## [1.0.0] - 2019-04-25

### Changed

- [#7002: scoring-horse-racingプロジェクトをinvestment-horse-racingプロジェクトにリネームする](https://redmine.u6k.me/issues/7002)

## [0.7.0] - 2019-03-27

### Added

- [#6840: コマンド引数にクロール開始URLを指定する](https://redmine.u6k.me/issues/6840)
- [#6843: サブコマンドのオプションに、できるだけデフォルト値を設定する](https://redmine.u6k.me/issues/6843)

## [0.6.0] - 2019-03-22

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
