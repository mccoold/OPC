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
class SrvList < Jaas
  def service_list(domain_id, user, passwd)
    # list all instances in an account
    uri = URI.parse("https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/#{domain_id}")
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth "#{user}", "#{passwd}"
    request.add_field 'X-ID-TENANT-NAME', "#{domain_id}"
    response = http.request(request)
    response
  end # end method servicelist

  def inst_list(domain_id, user, passwd, inst_id)
    # provides details on an instance
    uri = URI.parse("https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/#{domain_id}/#{inst_id}")
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth "#{user}", "#{passwd}"
    request.add_field 'X-ID-TENANT-NAME', "#{domain_id}"
    http.request(request)
  end # end method instlist

  def managed_list(domain_id, user, passwd, inst_id)
    # provides details on an instance
    uri = URI.parse("https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/#{domain_id}/#{inst_id}/servers")
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth "#{user}", "#{passwd}"
    request.add_field 'X-ID-TENANT-NAME', "#{domain_id}"

    response = http.request(request)
    if response.code == '200'
      JSON.parse(response.body)
    else
      puts 'ERROR!!!'
    end  # end if/else
  end # end method manlist
end # end class
