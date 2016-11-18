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
class DbaasManager < Dbcs
  def initialize(id_domain, user, passwd)
    @id_domain = id_domain
    @user = user
    @passwd = passwd
    proxy = Proxy.new
    proxy = proxy.proxy
    @proxy_addr = proxy.at(0)
    @proxy_port = proxy.at(1)
    @url = 'https://dbaas.oraclecloud.com/paas/service/dbcs/api/v1.1/instances/'
  end
  attr_writer :url

  def scale_up(data, inst_id) # rubocop:disable Metrics/AbcSize
    uri = URI.parse(@url + @id_domain + '/' + inst_id)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Put.new(uri.request_uri)
    request.basic_auth @user, @passwd
    request.add_field 'X-ID-TENANT-NAME', @id_domain
    request.add_field 'Content-Type', 'application/json'
    http.request(request, data.to_json)
  end

  # turns an instance on and off
  def power(inst_id, action) # rubocop:disable Metrics/AbcSize
    config = {
      'lifecycleState'   => "#{action}"
    }
    url = @url + @id_domain + '/' + inst_id
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.basic_auth @user, @passwd
    request.add_field 'Content-Type', 'application/json'
    request.add_field 'X-ID-TENANT-NAME', @id_domain
    http.request(request, config.to_json)
  end
end
