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
class Container < Paas
  def initialize(id_domain, user, passwd, service)
    @id_domain = id_domain
    @user = user
    @passwd = passwd
    proxy = Proxy.new
    proxy = proxy.proxy
    @proxy_addr = proxy.at(0)
    @proxy_port = proxy.at(1)
    @url = 'https://apaas.oraclecloud.com/paas/service/apaas/api/v1.1/apps/'
  end
  
  attr_writer :url, :service, :manifest, :deploymentfile, :applicationfile, :app_id, :action
  
  def uri_handler
    uri = URI.parse(@url) if @action == 'create'
    uri = URI.parse(@url + '/@id_domain/@app_id/restart') if @action == 'restart'
    uri = URI.parse(@url + '/@id_domain/@app_id/start') if @action == 'start'
    uri = URI.parse(@url + '/@id_domain/@app_id/stop') if @action == 'stop'
    uri = URI.parse(@url + '/@id_domain/@app_id') if @action == 'delete' || @action == 'update'
    if @action == 'list'
      uri = URI.parse(@url + '/@id_domain')if @app_id.nil?
      uri = URI.parse(@url + '/@id_domain/@app_id') unless @app_id.nil?
    end
  end
  
  def manage
    uri = uri_handler
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port) # Creates a http object
    http.use_ssl = true     # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri) unless @action == 'update'
    request = Net::HTTP::Put.new(uri.request_uri) if @action == 'update'
    request.basic_auth @user, @passwd
    request.add_field 'X-ID-TENANT-NAME', @id_domain
    request.add_field 'Content-Type', 'multipart/form-data' 
    http.request(request, @application_file, @manifest, @deployment_file)
  end
  
  def delete(inst_id) # rubocop:disable Metrics/AbcSize
    uri = uri_handleruri_handler
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Delete.new(uri.request_uri)
    request.basic_auth @user, @passwd
    request.add_field 'X-ID-TENANT-NAME', @id_domain
    http.request(request)
  end
  
  def list
    uri = uri_handler
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port) # Creates a http object
    http.use_ssl = true     # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri) 
    request.basic_auth @user, @passwd
    request.add_field 'X-ID-TENANT-NAME', @id_domain
    http.request(request)
  end
end    
