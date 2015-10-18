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
# WITHOUT WARRANTIE S OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
class BlockStorage < Iaas
  def list(restendpoint, container, action, id_domain, user, passwd)
    authcookie = ComputeBase.new
    authcookie = authcookie.authenticate(id_domain, user, passwd)
    url = restendpoint + '/storage/volume' + container
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.add_field 'accept', 'application/oracle-compute-v3+json' if action == 'details'
    request.add_field 'accept', 'application/oracle-compute-v3+directory+json' if action == 'list'
    request.add_field 'Cookie', authcookie
    response = http.request(request)
  end # end or method 
  
  def update(restendpoint, action, id_domain, user, passwd, *data)
    data_hash = data.at(0)
    authcookie = ComputeBase.new
    authcookie = authcookie.authenticate(id_domain, user, passwd)
    url = restendpoint + '/storage/volume/'
    uri = URI.parse(url) 
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri) if action == 'create'
    request = Net::HTTP::Delete.new(uri.request_uri) if action == 'delete'
    request.add_field 'Content-type', 'application/oracle-compute-v3+json'
    request.add_field 'accept', 'application/oracle-compute-v3+json'
    request.add_field 'Cookie', authcookie
    response = http.request(request, data_hash.to_json) unless action == 'delete'
    response = http.request(request) if action == 'delete'
end # end or method

def attach(restendpoint, action, id_domain, user, passwd, *data)
    data_hash = data.at(0)
    authcookie = ComputeBase.new
    authcookie = authcookie.authenticate(id_domain, user, passwd)
    url = restendpoint + '/storage/attachment/'
    uri = URI.parse(url) 
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri) if action == 'attach'
    request = Net::HTTP::Delete.new(uri.request_uri) if action == 'detach'
    request.add_field 'Content-type', 'application/oracle-compute-v3+json'
    request.add_field 'accept', 'application/oracle-compute-v3+json'
    request.add_field 'Cookie', authcookie
    response = http.request(request, data_hash.to_json) unless action == 'delete'
    response = http.request(request) if action == 'delete'
end # end or method

end