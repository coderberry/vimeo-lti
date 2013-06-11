require 'singleton'

class NonceStore
  include Singleton

  attr_accessor :nonces

  def initialize
    @nonces = {}
  end

  def include?(nonce, min=60)
    return true unless nonce &&  nonce.length > 0
    clean!(min)

    if @nonces.values.flatten.include? nonce
      true
    else
      @nonces[ts] ||= []
      @nonces[ts] << nonce
      false
    end
  end

  # removes nonces which were used prior to 60 minutes ago
  def clean!(min=60)
    ts_ago = round(Time.now - 60*min)
    @nonces.delete_if { |k,v| k <= ts_ago.to_i }
  end

  def ts
    round(Time.now)
  end

  def round(t=Time.now)
    (t - t.sec).to_i
  end

  def to_s
    @nonces.inspect.to_s
  end
    
end