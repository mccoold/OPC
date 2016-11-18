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
               @cfgfile = Hash[*File.read("#{fpath}" + '\opcclientcfg.conf').split(/[= \n]+/)]
               puts @cfgfile['proxy_addr']
               @proxy_addr = @cfgfile['proxy_addr']
               @proxy_port = @cfgfile['proxy_port']
             else
               @proxy_addr = nil
               @proxy_port = nil
             end
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
             end
           when /solaris|bsd/
             fpath = ENV['HOME']
             if File.exist?("#{fpath}" + '/opcclientcfg.conf')
               @cfgfile = Hash[*File.read("#{fpath}" + '/opcclientcfg.conf').split(/[= \n]+/)]
               @proxy_addr = @cfgfile['proxy_addr']
               @proxy_port = @cfgfile['proxy_port']
             else
               @proxy_addr = nil
               @proxy_port = nil
             end
           else
             fail Error::WebDriverError, "unknown os: #{host_os.inspect}"
           end
          )
          
    return @proxy_addr, @proxy_port
  end
  
  attr_reader :cfgfile
  
end
