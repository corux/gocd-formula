require "serverspec"

set :backend, :exec

describe service("go-server") do
  it { should be_enabled }
  it { should be_running }
end

describe port("8153") do
  it { should be_listening }
end

describe command("curl -L localhost:8153") do
  its(:stdout) { should match /Go Version/ }
end
