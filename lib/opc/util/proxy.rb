class Proxy < Util
  def proxy
    @os ||=
          (
           host_os = RbConfig::CONFIG['host_os']
           case host_os
           when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
             # :windows
             fpath = ENV['HOMEPATH']
             if File.exist?("#{fpath}" + '\opcclientcfg.conf')
               cfgfile = Hash[*File.read("#{fpath}" + '\opcclientcfg.conf').split(/[= \n]+/)]
               @proxy_addr = cfgfile['proxy_addr']
               @proxy_port = cfgfile['proxy_port']
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
               cfgfile = Hash[*File.read("#{fpath}" + '/opcclientcfg.conf').split(/[= \n]+/)]
               @proxy_addr = cfgfile['proxy_addr']
               @proxy_port = cfgfile['proxy_port']
             else
               @proxy_addr = nil
               @proxy_port = nil
             end # end of linux if
           when /solaris|bsd/
             fpath = ENV['HOME']
             if File.exist?("#{fpath}" + '/opcclientcfg.conf')
               cfgfile = Hash[*File.read("#{fpath}" + '/opcclientcfg.conf').split(/[= \n]+/)]
               @proxy_addr = cfgfile['proxy_addr']
               @proxy_port = cfgfile['proxy_port']
             else
               @proxy_addr = nil
               @proxy_port = nil
             end # end of unix if
           else
             fail Error::WebDriverError, "unknown os: #{host_os.inspect}"
           end # end of case
          )
    return @proxy_addr, @proxy_port
  end # end of method
end
