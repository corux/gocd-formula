require "serverspec"

set :backend, :exec

describe service("go-agent") do
  it { should be_enabled }
  it { should be_running }
end
