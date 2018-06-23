class ChainMock
  include Waterfall

  def initialize(key:, val:, dam: false)
    @key = key
    @val = val
    @dam = dam
  end

  def call
    chain(@key) { @val }
    when_truthy { @dam }.
      dam { @val }
  end
end
