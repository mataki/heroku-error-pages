module Heroku::Command
  class ErrorPages < BaseWithApp

    def upload
      display "Start upload public/*.html"

      s3_files = public_html_list do |file_name, file|
        display "Upload #{file_name} to #{store_url(file_name)}"
        directory.files.create(key: store_url(file_name), body: file, public: true)
      end

      display "Finish to upload"
    end

    def config
    end

  private

    def storage(key_id = ENV["AWS_S3_KEY_ID"], secret_key = ENV["AWS_S3_SECRET_KEY"])
      Fog::Storage.new({
                         :aws_access_key_id      => key_id,
                         :aws_secret_access_key  => secret_key,
                         :provider               => 'AWS'
                       })
    end

    def directory(bucket = ENV["AWS_S3_BUCKET"])
      storage.directories.detect{|d| d.key == bucket }
    end

    def store_url(file_name)
      "error_pages/#{file_name}"
    end

    def public_html_list &block
      Dir.glob(File.join('.', 'public', "*.html")).map do |f|
        file_name = f.split('/').last
        yield file_name, File.open(f)
      end
    end

  end
end
