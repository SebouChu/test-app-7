ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    private

    # From ActiveStorage tests' TestHelper
    # Source:https://github.com/rails/rails/blob/v7.2.1.1/activestorage/test/test_helper.rb

    def create_blob_before_direct_upload(key: nil, filename: "hello.txt", byte_size:, checksum:, content_type: "text/plain", record: nil)
      ActiveStorage::Blob.create_before_direct_upload! key: key, filename: filename, byte_size: byte_size, checksum: checksum, content_type: content_type, record: record
    end

    def directly_upload_file_blob(filename: "racecar.jpg", content_type: "image/jpeg", record: nil)
      file = file_fixture(filename)
      byte_size = file.size
      checksum = OpenSSL::Digest::MD5.file(file).base64digest

      create_blob_before_direct_upload(filename: filename, byte_size: byte_size, checksum: checksum, content_type: content_type, record: record).tap do |blob|
        service = ActiveStorage::Blob.service.try(:primary) || ActiveStorage::Blob.service
        service.upload(blob.key, file.open)
      end
    end
  end
end
