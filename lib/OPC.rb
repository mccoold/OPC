#
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
class OPC

  require 'net/http'
  require 'json'
  require 'net/https'
  require 'uri'
  require 'opc/paas'
  require 'opc/iaas'
  require 'opc/util'
  require 'rbconfig'

  def initialize
    @os ||=
      (
       host_os = RbConfig::CONFIG['host_os']
       case host_os
       when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
         # :windows
         fpath = ENV['HOMEPATH']
           if File.exist?("#{fpath}" + '\opcclientcfg.conf')
             @cfgfile = Hash[*File.read("#{fpath}" + '\opcclientcfg.conf').split(/[= \n]+/)]
             @proxy_addr = @cfgfile['proxy_addr']
             @proxy_port = @cfgfile['proxy_port']
           else
             @proxy_addr = nil
             @proxy_port = nil
           end # end of windows if
       when /darwin|mac os/
         :macosx
       when /linux/
         #:linux
         fpath = ENV['HOME']
         if File.exist?("#{fpath}" + '/opcclientcfg.conf')
           @cfgfile = Hash[*File.read("#{fpath}" + '/opcclientcfg.conf').split(/[= \n]+/)]
           @proxy_addr = @cfgfile['proxy_addr']
           @proxy_port = @cfgfile['proxy_port']
         else
           @proxy_addr = nil
           @proxy_port = nil
         end # end of linux if
       when /solaris|bsd/
         fpath = ENV['HOME']
         if File.exist?("#{fpath}" + '/opcclientcfg.conf')
           @cfgfile = Hash[*File.read("#{fpath}" + '/opcclientcfg.conf').split(/[= \n]+/)]
           @proxy_addr = @cfgfile['proxy_addr']
           @proxy_port = @cfgfile['proxy_port']
         else
           @proxy_addr = nil
           @proxy_port = nil
         end # end of unix if
       else
         fail Error::WebDriverError, "unknown os: #{host_os.inspect}"
       end # end of case
      )
  end # end of method
  attr_reader :cfgfile
end # end of class

