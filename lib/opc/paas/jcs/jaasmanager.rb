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
class JaasManager < Jcs
  def initialize(id_domain, user, passwd)
    @id_domain = id_domain
    @user = user
    @passwd = passwd
    proxy = Proxy.new
    proxy = proxy.proxy
    @proxy_addr = proxy.at(0)
    @proxy_port = proxy.at(1)
    @timeout = '10'
  end

  attr_writer :url, :timeout

  def mngstate(inst_id, action)
    config = {
      'lifecycleState'   => action,
      'lifecycleTimeout' => @timeout
             }
    url =  @url + @id_domain + '/' + inst_id
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.basic_auth @user, @passwd
    request.add_field 'Content-Type', 'application/vnd.com.oracle.oracloud.provisioning.Service+json'
    request.add_field 'X-ID-TENANT-NAME', @id_domain
    http.request(request, config.to_json)
  end   # end method stop

  def scale_up(inst_id, cluster_id)
    url = @url + @id_domain + '/' + inst_id + '/servers/' + cluster_id
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.basic_auth @user, @passwd
    request.add_field 'X-ID-TENANT-NAME', @id_domain
    http.request(request)
  end # end of method

  def scale_in(inst_id, server_id)
    url = @url + @id_domain + "/#{inst_id}/servers/#{server_id}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Delete.new(uri.request_uri)
    request.basic_auth @user, @passwd
    request.add_field 'X-ID-TENANT-NAME', @id_domain
    http.request(request)
  end  # end of method

  def patch_precheck(inst_id, patch_id)
    url = @url + @id_domain + "/#{inst_id}/patches/checks/#{patch_id}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth @user, @passwd
    request.add_field 'X-ID-TENANT-NAME', @id_domain
    http.request(request)
  end # end of method

  def patch(inst_id, patch_id)
    url = @url + @id_domain + "/#{inst_id}/patches/#{patch_id}"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Put.new(uri.request_uri)
    request.basic_auth @user, @passwd
    request.add_field 'X-ID-TENANT-NAME', @id_domain
    http.request(request)
  end # end of method

  def patch_rollback(inst_id, rollback_id)
    url = @url + @id_domain + "/#{inst_id}/patches/#{rollback_id}/rollback"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Put.new(uri.request_uri)
    request.basic_auth @user, @passwd
    request.add_field 'X-ID-TENANT-NAME', @id_domain
    http.request(request)
  end # end of method

  def applied_patches(inst_id)
    url = @url + @id_domain + "/#{inst_id}/patches/applied"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth @user, @passwd
    request.add_field 'X-ID-TENANT-NAME', @id_domain
    http.request(request)
  end # end of method

  def available_patches(inst_id)
    url = @url + @id_domain + "/#{inst_id}/patches/available"
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth @user, @passwd
    request.add_field 'X-ID-TENANT-NAME', @id_domain
    http.request(request)
  end # end of method
end # end of class
