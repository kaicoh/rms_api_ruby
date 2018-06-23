RSpec.shared_context "use webmock", shared_context: :metadata do
  before :all do
    WebMock.enable!
  end

  after :all do
    WebMock.reset!
    WebMock.disable!
  end
end

RSpec.configure do |config|
  config.include_context "use webmock", include_shared: true
end
