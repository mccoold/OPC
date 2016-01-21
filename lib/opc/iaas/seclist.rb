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
class SecList < Iaas
  def initialize(id_domain, user, passwd) # rubocop:disable Metrics/AbcSize
    @id_domain = id_domain
    @user = user
    @passwd = passwd
    proxy = Proxy.new
    proxy = proxy.proxy
    @proxy_addr = proxy.at(0)
    @proxy_port = proxy.at(1)
  end

  def list(restendpoint, container, action) # rubocop:disable Metrics/AbcSize
    authcookie = ComputeBase.new
    authcookie = authcookie.authenticate(@id_domain, @user, @passwd, restendpoint)
    url = restendpoint + '/seclist/Compute-' + @id_domain + container
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.add_field 'accept', 'application/oracle-compute-v3+json' if action == 'details'
    request.add_field 'accept', 'application/oracle-compute-v3+directory+json' if action == 'discover'
    request.add_field 'Cookie', authcookie
    http.request(request)
  end # end or method

  def discover(restendpoint, container, action) # rubocop:disable Metrics/AbcSize
    authcookie = ComputeBase.new
    authcookie = authcookie.authenticate(@id_domain, @user, @passwd, restendpoint)
    url = restendpoint + '/seclist/Compute-' + @id_domain + container
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.add_field 'accept', 'application/oracle-compute-v3+json' if action == 'details'
    request.add_field 'accept', 'application/oracle-compute-v3+directory+json' if action == 'list'
    request.add_field 'Cookie', authcookie
    http.request(request)
  end # end or method

  def update(restendpoint, seclist, action, *data) # rubocop:disable Metrics/AbcSize
    data_hash = data.at(0)
    authcookie = ComputeBase.new
    authcookie = authcookie.authenticate(@id_domain, @user, @passwd, restendpoint)
    url = restendpoint + '/seclist' + seclist if action == 'update' || action == 'delete'
    url = restendpoint + '/seclist/' if action == 'create'
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Put.new(uri.request_uri) if action == 'update'
    request = Net::HTTP::Post.new(uri.request_uri) if action == 'create'
    request = Net::HTTP::Delete.new(uri.request_uri) if action == 'delete'
    request.add_field 'Content-type', 'application/oracle-compute-v3+json'
    request.add_field 'accept', 'application/oracle-compute-v3+json'
    request.add_field 'Cookie', authcookie
    return  http.request(request, data_hash.to_json) unless action == 'delete'
    return  http.request(request) if action == 'delete'
  end # end or method
end
