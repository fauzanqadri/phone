module Phone    
  class Message
    class_attribute :phone_number, :message
    
    def initialize attribute = {}
      @phone_number = attribute[:phone_number] || nil
      @message = attribute[:message] || nil    
    end
      
    def self.class_identifier
      self.to_s.split('::')
    end
    
    def self.modul
      "Phone::#{self.class_identifier[1]}".constantize
    end
    
    
    class << self
      def hello
        puts modul
      end
    end
    
    def send
      self.class.modul.send_command("CMGF=1")
      sleep 1
      if @phone_number.class == Array
        @phone_number.each do |phone_number|
          sending phone_number
        end
      else
        sending @phone_number
      end
      @message.length
    end
    
    private
    def sending phone_number
      self.class.modul.send_command("CMGW=\"#{phone_number}\"")
      self.class.modul.send_text("#{@message}#{26.chr}\r")
      sleep 2
      res = self.class.modul.result
      res_regex = /^(\W...W: \d)/
      index_array = res_regex.match(res)
      index = if index_array.class == MatchData
        index_array.to_a.last.to_s.split(':').last[1..-1].to_i
      else
        raise Phone::FailedToCreateSms.new 
      end
      self.class.modul.send_command("CMSS=#{index}")
    end
  end
  
end