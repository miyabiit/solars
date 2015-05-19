# solars
Mega Solar watcher project

準備
----

* nokogiriに必要なライブラリ
* nokogiriのコンパイルに必要なツール
* phantomjs

```
  brew install libxml2
  brew install libxslt
  brew link libxml2 --force
  brew link libxslt --force
  xcode-select --install
  brew install phantomjs
  bundle install --path vendor/bundle
  bundle exec ruby app/solar_parse.rb
```
