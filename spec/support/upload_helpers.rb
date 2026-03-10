# frozen_string_literal: true

module UploadHelpers
  def fake_image(filename = "test.png")
    Rack::Test::UploadedFile.new(
      StringIO.new(File.read(Rails.root.join("spec/fixtures/files/test.png"))),
      "image/png",
      true,
      original_filename: filename
    )
  end

  def fake_request
    ActionDispatch::TestRequest.create
  end
end

RSpec.configure do |config|
  config.include UploadHelpers
end
