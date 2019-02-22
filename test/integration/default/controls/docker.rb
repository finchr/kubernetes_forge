# encoding: utf-8
# copyright: 2015, The Authors

title 'docker status'

describe docker.version do
  its('Server.Version') { should cmp >= '18.06'}
  its('Client.Version') { should cmp >= '18.06'}
end

describe docker.info do
  its('LoggingDriver') { should eq 'json-file' }
end
