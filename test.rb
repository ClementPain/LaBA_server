require 'fakefs/safe'
require 'open-uri'

FakeFS do; end

temp = URI.open('/dev/null')
temp.close
temp = URI.open('https://google.com/')
temp.close