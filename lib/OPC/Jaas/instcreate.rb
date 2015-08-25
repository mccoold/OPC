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
# limitations under the License.class OPC
#
class InstCreate < Jaas
  def create(data, id_domain, user, passwd)
    url = "https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/#{id_domain}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port) # Creates a http object
    http.use_ssl = true     # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    # initheader = { ':Content-Type' => 'application/vnd.com.oracle.oracloud.provisioning.Service+json' }
    request = Net::HTTP::Post.new(uri.request_uri)
    request.basic_auth "#{user}", "#{passwd}"
    request.add_field 'X-ID-TENANT-NAME', "#{id_domain}"
    request.add_field 'Content-Type', 'application/vnd.com.oracle.oracloud.provisioning.Service+json'
    response = http.request(request, data.to_json)
    response
  end   # end method create

  def create_status(url, domain_id, user, passwd)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http. use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth "#{user}", "#{passwd}"
    request.add_field 'X-ID-TENANT-NAME', "#{domain_id}"
    response = http.request(request)
    response.body
  end
end   # end of class
