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
class DataGrid < Jaas
  def create(inst_id, id_domain, user, passwd)
    url = "https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/#{id_domain}/#{inst_id}/clusters"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port) # Creates a http object
    http.use_ssl = true     # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.basic_auth "#{user}", "#{passwd}"
    request.add_field 'X-ID-TENANT-NAME', "#{id_domain}"
    request.add_field 'Content-Type', 'application/vnd.com.oracle.oracloud.datagrid.Service+json'
    http.request(request)
  end   # end method create

  def list(id_domain, user, passwd)
    url = "https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/datagrid/#{id_domain}/config/scalingUnits/defaultScalingUnits"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port) # Creates a http object
    http.use_ssl = true     # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.basic_auth "#{user}", "#{passwd}"
    request.add_field 'X-ID-TENANT-NAME', "#{id_domain}"
    request.add_field 'Content-Type', 'application/vnd.com.oracle.oracloud.datagrid.Service+json'
    http.request(request, data.to_json)
  end   # end method create

  def delete(inst_id, id_domain, user, passwd)
    url = "https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/#{id_domain}/#{inst_id}/clusters"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port) # Creates a http object
    http.use_ssl = true     # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.basic_auth "#{user}", "#{passwd}"
    request.add_field 'X-ID-TENANT-NAME', "#{id_domain}"
    request.add_field 'Content-Type', 'application/vnd.com.oracle.oracloud.datagrid.Service+json'
    http.request(request, data.to_json)
  end   # end method create
end
