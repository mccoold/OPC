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
class Instance < Iaas
  def initialize(id_domain, user, passwd, restendpoint)
    @id_domain = id_domain
    @user = user
    @passwd = passwd
    proxy = Proxy.new
    proxy = proxy.proxy
    @proxy_addr = proxy.at(0)
    @proxy_port = proxy.at(1)
    @restendpoint = restendpoint
  end

  def list(container, action) # rubocop:disable Metrics/AbcSize
    authcookie = ComputeBase.new
    authcookie = authcookie.authenticate(@id_domain, @user, @passwd, @restendpoint)
    url = @restendpoint + '/instance' + container
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.add_field 'accept', 'application/oracle-compute-v3+json' if action == 'details'
    request.add_field 'accept', 'compute-v3+directory+json' if action == 'list'
    request.add_field 'Cookie', authcookie
    http.request(request)
  end

  def delete(instance) # rubocop:disable Metrics/AbcSize
    authcookie = ComputeBase.new
    authcookie = authcookie.authenticate(@id_domain, @user, @passwd, @restendpoint)
    url = @restendpoint + '/instance' + instance
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Delete.new(uri.request_uri)
    request.add_field 'accept', 'application/oracle-compute-v3+json'
    request.add_field 'Cookie', authcookie
    http.request(request)
  end

  def list_ip(container) # rubocop:disable Metrics/AbcSize
    instance_data = JSON.parse(list(container, 'details').body)
    vcableid = instance_data['vcable_id']
    internalip = instance_data['ip']
    iputil = IPUtil.new(@id_domain, @user, @passwd, @restendpoint)
    basecontainer = container.split('/')
    usercontainer = '/' + basecontainer[1] + '/' + basecontainer[2] + '/'
    vcabledetails = JSON.parse(iputil.discover(usercontainer, 'vcable', vcableid, 'association').body)
    vcabledetails = vcabledetails['result']
    vcabledetails = vcabledetails.at(0)
    extipaddress = vcabledetails['ip']
    return internalip, extipaddress
  end
end
