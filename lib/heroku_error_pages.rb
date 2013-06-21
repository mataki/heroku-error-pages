require "fog"

module Heroku::Command
  class ErrorPages < Base

    def upload
      action "Start upload public/*.html" do
        s3_files = public_html_list do |file_name, file|
          display "Upload #{file_name} to #{store_url(file_name)}"
          directory.files.create(key: store_url(file_name), body: file, public: true)
        end
      end
    end

    def config(error_page_key = "500.html", maintenance_page_key = "503.html")
      action "Set config" do
        error_page = directory.files.get(store_url(error_page_key))
        maintenance_page = directory.files.get(store_url(maintenance_page_key))
        vars = {
          "ERROR_PAGE_URL" => error_page.public_url,
          "MAINTENANCE_PAGE_URL" => maintenance_page.public_url
        }
        styled_hash(vars)
        api.put_config_vars(app, vars)
      end
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
