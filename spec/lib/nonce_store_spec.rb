require File.expand_path("../../nonce_store.rb", __FILE__)

describe NonceStore do
  it "#include?" do
    ns = NonceStore.instance
    ns.include?('foo').should be_false
    ns.include?('bar').should be_false
    ns.include?('baz').should be_false
    ns.include?('foo').should be_true
    ns.existing_nonces.size.should == 3
  end

  it "#clean!" do
    ns = NonceStore.instance
    ts = Time.now - 60*90 # 90 minutes ago
    ns.nonces = { (ts - ts.sec).to_i => ['old', 'dingy', 'stinky'] }
    ns.nonces[ns.ts] = ['new', 'happy', 'lucky']
    ns.existing_nonces.size.should == 6
    ns.clean!
    ns.existing_nonces.size.should == 3
    ns.existing_nonces.should == ['new', 'happy', 'lucky']
  end
end