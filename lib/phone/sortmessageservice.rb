class SortMessageService
  
  def initialize
    class_identifier = self.class.to_s.split('::')
    @module = "Phone::#{class_identifier[1]}".constantize
    @module.configure
    @module.send_command("CMGF=1")
  end
      
  def create(param = {})
    @module.send_command("CMGW=\"#{param[:phone_number]}\"")
    @module.send_text("#{param[:message]}#{26.chr}\r")
    sleep 3
    result_regex = /^(\W...W: \d)/
    match = result_regex.match(@module.result)
      
    index = if match.class == MatchData && !match.nil?
      match.to_a.last.to_s.split(':')[1][1..-1].to_i
    else
      raise Phone::FailedToCreateSms.new
    end
    @module.send_command "CMSS=#{index}"
    true
  end
end

class Message
  attr_accessor :phone_number, :message
  attr_reader :date
  def initialize param = {}
    @phone_number = param[:phone_number]
    @message = param[:message]
    @date = Time.new
  end
end