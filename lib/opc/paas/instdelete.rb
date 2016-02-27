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
class InstDelete < Paas
  def initialize(id_domain, user, passwd, service) # rubocop:disable Metrics/AbcSize
    @service = service
    @id_domain = id_domain
    @user = user
    @passwd = passwd
    proxy = Proxy.new
    proxy = proxy.proxy
    @proxy_addr = proxy.at(0)
    @proxy_port = proxy.at(1)
    @url = 'https://jaas.oraclecloud.com/paas/service/soa/api/v1.1/instances/' + @id_domain if @service == 'soa'
    @url = 'https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/' + @id_domain if @service == 'jcs'
    @url = 'https://dbaas.oraclecloud.com/paas/service/dbcs/api/v1.1/instances/' + @id_domain if @service == 'dbcs'
  end

  attr_writer :url

  def delete(data, inst_id) # rubocop:disable Metrics/AbcSize
    uri = URI.parse(@url + "/#{inst_id}")
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Delete.new(uri.request_uri) if @service == 'dbcs'
    request = Net::HTTP::Put.new(uri.request_uri) if @service == 'jcs'
    request.basic_auth @user, @passwd
    request.add_field 'X-ID-TENANT-NAME', @id_domain
    request.add_field 'Content-Type', 'application/vnd.com.oracle.oracloud.provisioning.Service+json' if @service == 'jcs'
    request.add_field 'Content-Type', 'application/json' if @service == 'dbcs'
    response =  http.request(request, data.to_json) if @service == 'jcs'
    response =  http.request(request) if @service == 'dbcs'
    return response
  end # end of method delete
end   # end of class
