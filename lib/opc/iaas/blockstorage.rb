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
  require 'opc/account_helpers'
  include NimbulaAttr
  
  def initialize(options) # rubocop:disable Metrics/AbcSize
    @options = options
    proxy = Proxy.new
    proxy = proxy.proxy
    @proxy_addr = proxy.at(0)
    @proxy_port = proxy.at(1)
    @function = 'storage'
  end

attr_writer :function, :create_parms, :options

  # list method for Nimbula Block Storage
  # returns a http response object
  def list(action) # rubocop:disable Metrics/AbcSize
    authcookie = ComputeBase.new
    authcookie = authcookie.authenticate(id_domain, user, passwd, restendpoint)
    url = @restendpoint + '/storage/volume' + container unless @function == 'volume_snapshot'
    url = @restendpoint + '/storage/snapshot' + container if @function == 'volume_snapshot'
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    action = action.downcase
    request.add_field 'accept', 'application/oracle-compute-v3+json' if action == 'details'
    request.add_field 'accept', 'application/oracle-compute-v3+directory+json' if action == 'list'
    request.add_field 'Cookie', authcookie
    http.request(request)
  end # end or method

  # create, update, and delete functionality for Nimbuila block storage
  # returns a http response object
  def update(action) # rubocop:disable Metrics/AbcSize
    #  create compute auth cookie
    authcookie = ComputeBase.new
    authcookie = authcookie.authenticate(id_domain, user, passwd, restendpoint)
    # updating the url end point depending on the function
    url = restendpoint + '/storage/volume/' if @function == 'storage' && action == 'create'
    url = restendpoint + '/storage/volume' + container if @function == 'storage' && action == 'delete'
    url = restendpoint + '/storage/volume' + container if @function == 'storage' && action == 'update'
    url = restendpoint + '/storage/snapshot/' if @function == 'volume_snapshot'
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri) if action == 'create'
    request = Net::HTTP::Put.new(uri.request_uri) if action == 'update'
    request = Net::HTTP::Delete.new(uri.request_uri) if action == 'delete'
    request.add_field 'Content-type', 'application/oracle-compute-v3+json'
    request.add_field 'accept', 'application/oracle-compute-v3+json'
    request.add_field 'Cookie', authcookie
    return http.request(request, @create_parms.to_json) unless action == 'delete'
    return http.request(request) if action == 'delete'
  end # end or method

  # attaches a nimbula storage object to an instance
  # returns a http response object
  def attach(action) # rubocop:disable Metrics/AbcSize
    data_hash = data.at(0)
    #  create compute auth cookie
    authcookie = ComputeBase.new
    authcookie = authcookie.authenticate(id_domain, user, passwd, restendpoint)
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
    return http.request(request, data_hash.to_json) unless action == 'delete'
    return http.request(request) if action == 'delete'
  end # end or method
end
