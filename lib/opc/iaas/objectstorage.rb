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
class ObjectStorage < Iaas
  def initialize(id_domain, user, passwd) # rubocop:disable Metrics/AbcSize
    @id_domain = id_domain
    @user = user
    @passwd = passwd
    proxy = Proxy.new
    proxy = proxy.proxy
    @proxy_addr = proxy.at(0)
    @proxy_port = proxy.at(1)
    @url = 'https://' + @id_domain + '.storage.oraclecloud.com/auth/v1.0'
  end

  attr_writer :url 

  def build_token # rubocop:disable Metrics/AbcSize
    uri = URI.parse(@url)
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
    http.use_ssl = true    # When using https
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.add_field 'X-Storage-User', 'Storage-' + @id_domain + ':' + @user
    request.add_field 'X-Storage-Pass', @passwd
    response = http.request(request)
    if response.code == '200'
      return response['X-Storage-Url'], response['X-Auth-Token']
    else
      response
    end # end of if
  end # end of method

  def create(container) # rubocop:disable Metrics/AbcSize
    tokens = build_token
    if !tokens.is_a?(Array)
      return tokens
    else
      stgurl = tokens.at(0)
      stgurl = "#{stgurl}/#{container}"
      stgtkn = tokens.at(1)
      uri = URI.parse(stgurl)
      http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
      http.use_ssl = true  # When using https
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Put.new(uri.request_uri)
      request.add_field 'X-Auth-Token', "#{stgtkn}"
      http.request(request)
    end # end of if
  end  # end of method

  def list # rubocop:disable Metrics/AbcSize
    tokens = build_token
    if !tokens.is_a?(Array)
      return tokens
    else
      stgurl = tokens.at(0)
      stgurl =  "#{stgurl}"
      stgtkn = tokens.at(1)
      uri = URI.parse(stgurl)
      http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
      http.use_ssl = true        # When using https
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      request.add_field 'X-Auth-Token', "#{stgtkn}"
      http.request(request)
    end # end of if
  end  # end of method

  def contents(container) # rubocop:disable Metrics/AbcSize
    tokens = build_token
    if !tokens.is_a?(Array)
      return tokens
    else
      stgurl = tokens.at(0)
      stgurl = "#{stgurl}/#{container}"
      stgtkn = tokens.at(1)
      uri = URI.parse(stgurl)
      http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
      http.use_ssl = true         # When using https
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Get.new(uri.request_uri)
      request.add_field 'X-Auth-Token', "#{stgtkn}"
      http.request(request)
    end
    # end of if
  end  # end of method

  def delete(container) # rubocop:disable Metrics/AbcSize
    tokens = build_token
    if !tokens.is_a?(Array)
      return tokens
    else
      stgurl = tokens.at(0)
      stgurl = "#{stgurl}/#{container}"
      stgtkn = tokens.at(1)
      uri = URI.parse(stgurl)
      http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
      http.use_ssl = true         # When using https
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Delete.new(uri.request_uri)
      request.add_field 'X-Auth-Token', "#{stgtkn}"
      http.request(request)
    end # end of if
  end  # end of method

  def object_create(local_file_name, container, object_name, file_type) # rubocop:disable Metrics/AbcSize
    require 'net/http/post/multipart'
    tokens = build_token
    if !tokens.is_a?(Array)
      return tokens
    else
      stgurl = tokens.at(0)
      stgurl = "#{stgurl}/#{container}/#{object_name}"
      stgtkn = tokens.at(1)
      uri = URI.parse(stgurl)
      http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)   # Creates a http object
      http.use_ssl = true  # When using https
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      File.open(local_file_name) do |f|
        request = Net::HTTP::Post::Multipart.new uri.path, 'file' => UploadIO.new(f, "#{file_type}")
        request.add_field 'X-Auth-Token', "#{stgtkn}"
        request = http.start do |http|
          http.request(request)
        end # end of loop for request
      end # end of file loop
    end # end of if for tokens
  end  # end of method
end # end of class
