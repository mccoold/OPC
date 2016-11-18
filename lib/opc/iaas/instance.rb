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
  require 'opc/account_helpers'
  include NimbulaAttr
  
  def initialize(options)
    @options = options
    proxy = Proxy.new
    proxy = proxy.proxy
    @proxy_addr = proxy.at(0)
    @proxy_port = proxy.at(1)
    @function = '/instance'
  end

attr_writer :function, :machine_image, :options

  # Gets a list of all the instances in the specified container.
  # You can limit the list by specifying an instance name and details as the action
  def list # rubocop:disable Metrics/AbcSize
    authcookie = ComputeBase.new
    authcookie = authcookie.authenticate(id_domain, user, passwd, restendpoint)
    url = restendpoint + @function + container
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.add_field 'accept', 'application/oracle-compute-v3+json' if action == 'details'
    request.add_field 'accept', 'application/oracle-compute-v3+directory+json' if action == 'list'
    request.add_field 'Cookie', authcookie
    http.request(request)
  end

  # deletes instances
  def delete(instance) # rubocop:disable Metrics/AbcSize
    authcookie = ComputeBase.new
    authcookie = authcookie.authenticate(id_domain, user, passwd, restendpoint)
    url = restendpoint + @function + instance
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Delete.new(uri.request_uri)
    request.add_field 'accept', 'application/oracle-compute-v3+json'
    request.add_field 'Cookie', authcookie
    http.request(request)
  end
  
  # creates instance snap shot of instances with ephemeral disk allocated(only)
  def create_snap # rubocop:disable Metrics/AbcSize
    authcookie = ComputeBase.new
    authcookie = authcookie.authenticate(id_domain, user, passwd, restendpoint)
    url = restendpoint + @function
    uri = URI.parse(url)
    #account = '/Compute-' + @id_domain + '/' + @user
    account = '/Compute-' + id_domain + '/cloud_storage'
    create_data = Hash.new
    create_data = { 'account' => account, 'instance' => container }
    create_data['machineimage'] = @machine_image if !@machine_image.nil?
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.add_field 'Cookie', authcookie
    request.add_field 'Content-type', 'application/oracle-compute-v3+json'
    http.request(request, create_data.to_json)
  end

  # gets the public and private IP's for instances in compute
  def list_ip(container) # rubocop:disable Metrics/AbcSize
    instance_data = list.body
    instance_data = JSON.parse(instance_data)
    instance_data = instance_data['result']
    instance_data = instance_data.at(0)
    vcableid = instance_data['vcable_id']
    abort('Error network configuration is not present') if vcableid.nil?
    internalip = instance_data['ip']
    iputil = IPUtil.new(id_domain, user, passwd, restendpoint)
    basecontainer = container.split('/')
    usercontainer = '/' + basecontainer[1] + '/' + basecontainer[2] + '/'
    vcabledetails = JSON.parse(iputil.discover(usercontainer, 'vcable', vcableid, 'association').body)
    vcabledetails = vcabledetails['result']
    vcabledetails = vcabledetails.at(0)
    extipaddress = vcabledetails['ip']
    return internalip, extipaddress
  end
end
