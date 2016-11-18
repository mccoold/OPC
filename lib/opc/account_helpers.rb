module NimbulaAttr
  def id_domain
    id_domain = @options[:id_domain]
  end 
  
  def user
    user = @options[:user_name]
  end
  
  def passwd
    passwd = @options[:passwd]
  end
  
  def restendpoint
    restendpoint = @options[:rest_endpoint]
  end
  
  def container
    container = @options[:container]
  end
  
  def action
    action = @options[:action]
  end
  
  def service
    service = @options[:function]
    service = service.downcase
  end
end