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
class BackUpManager < Jaas
  def backup_config_list(inst_id, domain_id, user, passwd)
    # list all instances in an account
    uri = URI.parse("https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/#{domain_id}/#{inst_id}/backupconfig")
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth "#{user}", "#{passwd}"
    request.add_field 'X-ID-TENANT-NAME', "#{domain_id}"
    http.request(request)
  end # end method backuplist

  def backup_config(data, inst_id, domain_id, user, passwd)
    # list all instances in an account
    uri = URI.parse("https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/#{domain_id}/#{inst_id}/backupconfig")
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.basic_auth "#{user}", "#{passwd}"
    request.add_field 'X-ID-TENANT-NAME', "#{domain_id}"
    request.add_field 'Content-type:application/json'
    http.request(request, data.to_json)
  end # end method backuplist

  def backup_initialize(data, inst_id, domain_id, user, passwd)
    # list all instances in an account
    uri = URI.parse("https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/#{domain_id}/#{inst_id}/backups")
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.basic_auth "#{user}", "#{passwd}"
    request.add_field 'X-ID-TENANT-NAME', "#{domain_id}"
    request.add_field 'Content-type', 'application/json'
    http.request(request, data.to_json)
  end # end method initialize

  def backup_list(inst_id, backup_id, domain_id, user, passwd)
    # list all backups in an account
    if !backup_id.nil?
      uri = URI.parse("https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/#{domain_id}/#{inst_id}/backups/#{backup_id}")
    else
      uri = URI.parse("https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/#{domain_id}/#{inst_id}/backups")
    end # end of if
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    request.basic_auth "#{user}", "#{passwd}"
    request.add_field 'X-ID-TENANT-NAME', "#{domain_id}"
    request.add_field 'Content-type', 'application/json'
    http.request(request)
  end # end method backup list

  def backup_delete(data, inst_id, domain_id, user, passwd)
    # list all instances in an account
    uri = URI.parse("https://jaas.oraclecloud.com/paas/service/jcs/api/v1.1/instances/#{domain_id}/#{inst_id}/deletedbackups")
    http = Net::HTTP.new(uri.host, uri.port, @proxy_addr, @proxy_port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Post.new(uri.request_uri)
    request.basic_auth "#{user}", "#{passwd}"
    request.add_field 'X-ID-TENANT-NAME', "#{domain_id}"
    request.add_field 'Content-type:application/json'
    http.request(request, data.to_json)
  end # end method initialize
end
