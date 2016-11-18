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
class ComputeBase < Iaas
  # creates the user token for nimbula IaaS authtentication, can not be used for PaaS or Object Storage
  def authenticate(id_domain, user, passwd, restendpoint) # rubocop:disable Metrics/AbcSize
    url = restendpoint + '/authenticate/'
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    euser = '/Compute-' + id_domain + '/' + user
    data = { 'user' => euser, 'password' => passwd }
    request.add_field 'Content-type', 'application/oracle-compute-v3+json'
    request.add_field 'accept', 'application/oracle-compute-v3+json'
    response = http.request(request, data.to_json)
    if response.code == '204'
      response['Set-Cookie']
    else
      abort('authentication failed ' + response.body)
    end
  end
end
