RSpec.shared_context "shared logger", shared_context: :metadata do
  let(:logger_mock) { double('Logger mock') }

  before do
    allow(logger_mock).to receive(:debug)
    allow(logger_mock).to receive(:info)
    allow(logger_mock).to receive(:warning)
    allow(logger_mock).to receive(:error)
    allow(logger_mock).to receive(:fatal)
    allow(logger_mock).to receive(:level=)
    allow(RmsApiRuby).to receive_message_chain('configuration.logger').
      and_return(logger_mock)
    allow(RmsApiRuby).to receive_message_chain('configuration.log_level')
  end
end

RSpec.configure do |config|
  config.include_context "shared logger", include_shared: true
end
