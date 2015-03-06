
require 'serverspec'

describe service('haproxy') do
  it { should be_running }
end

describe port(80) do
  it { should be_listening }
end
