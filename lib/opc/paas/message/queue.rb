# Author:: Daryn McCool (<mdaryn@hotmail.com>)
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class Queue < Message
  def initialize(id_domain, user, passwd, restendpoint)
    @id_domain = id_domain
    @user = user
    @passwd = passwd
    proxy = Proxy.new
    proxy = proxy.proxy
    @proxy_addr = proxy.at(0)
    @proxy_port = proxy.at(1)
    @url = restendpoint + '/MCSService03-MCSOracle3/api/v1/queues/' 
  end

  def create(queuename, queuedata)
    url = @url + queuename
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Put.new(uri.request_uri)
    request.basic_auth @user, @passwd
    request.add_field 'accept', 'application/json, application/xml'
    # request.add_field 'accept', 'application/oracle-compute-v3+directory+json' if action == 'list'
    request.add_field 'Cookie', authcookie
    http.request(request)
  end # end or method
  
  def delete(restendpoint, queuename, queuedata)
    url = restendpoint + '/MCSService03-MCSOracle3/api/v1/queues/' + queuename
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Delete.new(uri.request_uri)
    request.basic_auth @user, @passwd
    request.add_field 'accept', 'application/json, application/xml'
    # request.add_field 'accept', 'application/oracle-compute-v3+directory+json' if action == 'list'
    request.add_field 'Cookie', authcookie
    http.request(request)
  end # end or method
end
