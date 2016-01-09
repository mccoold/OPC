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
class SrvList < Paas
  def initialize(id_domain, user, passwd, service)
    @id_domain = id_domain
    @user = user
    @passwd = passwd
    proxy = Proxy.new
    proxy = proxy.proxy
    @proxy_addr = proxy.at(0)
    @proxy_port = proxy.at(1)
    @url = 'https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/' + @id_domain if service == 'jcs'
    @url = 'https://dbaas.oraclecloud.com/paas/service/dbcs/api/v1.1/instances/' + @id_domain if service == 'dbcs'
    @url = 'https://jaas.oraclecloud.com/paas/service/soa/api/v1.1/instances/' + @id_domain  if service == 'soa'
  end

  attr_writer :url

  def service_list
    # list all instances in an account
    uri = URI.parse(@url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth @user, @passwd
    request.add_field 'X-ID-TENANT-NAME', @id_domain
    http.request(request)
  end # end method servicelist

  def inst_list(service, inst_id)
    # provides details on an instance
    uri = URI.parse(@url + '/' + inst_id) 
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth @user, @passwd
    request.add_field 'X-ID-TENANT-NAME', @id_domain
    http.request(request)
  end # end method instlist

  def managed_list(inst_id)
    # provides details on an instance
    uri = URI.parse(@url + "/#{inst_id}/servers")
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth @user, @passwd
    request.add_field 'X-ID-TENANT-NAME', @id_domain
    http.request(request)
    
  end # end method manlist
end # end class

