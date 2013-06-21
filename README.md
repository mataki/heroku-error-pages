# heroku error pages tool

A heroku CLI plugin for error pages

### Installation

```bash
~ ➤ /usr/local/heroku/ruby/bin/gem install fog # FIXME: pack to vendor
~ ➤ heroku plugins:install git://github.com/mataki/heroku-error-pages.git
```

### Usage

Upload to S3 public html files

```bash
~ ➤ AWS_S3_KEY_ID="key_id" AWS_S3_SECRET_KEY="secret_key" AWS_S3_BUCKET="bucket_name" heroku errorpages:upload
````

Set heroku config of error pages

```bash
~ ➤ AWS_S3_KEY_ID="key_id" AWS_S3_SECRET_KEY="secret_key" AWS_S3_BUCKET="bucket_name" heroku errorpages:config
````
