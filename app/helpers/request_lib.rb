module RequestLib
  def self.server_name(request)
    result = "#{request.protocol}#{request.host}"
    if request.port != nil: result += ':' + request.port.to_s end
    result
  end
end
