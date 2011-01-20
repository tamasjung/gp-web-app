require "net/https"
require "uri"



uri = URI.parse("https://testce.grid.niif.hu:60000/arex/28653129544837314441029")
pem = File.read("/Users/tamas/.arc/certs/current/userCerts/usercert-jt.pem")
key = File.read("/Users/tamas/.arc/certs/current/userCerts/userkey-jt.pem")
http = Net::HTTP.new(uri.host, uri.port)
http.use_ssl = true
http.cert = OpenSSL::X509::Certificate.new(pem)
http.key = OpenSSL::PKey::RSA.new(key)
#http.verify_mode = OpenSSL::SSL::VERIFY_PEER
http.verify_mode = OpenSSL::SSL::VERIFY_NONE
request = Net::HTTP::Get.new(uri.request_uri)
response = http.request(request)
#response.body
#response.status
p response.content_length
p response.body