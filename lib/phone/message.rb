module Phone    
  class Message
    class_attribute :phone_number, :message
    
    def initialize attribute = {}
      @phone_number = attribute[:phone_number] || nil
      @message = attribute[:message] || nil    
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
    
    class << self
      
      def class_identifier
        self.to_s.split('::')
      end
    
      def modul
        "Phone::#{self.class_identifier[1]}".constantize
      end
    
      def inbox
        res = read_message
        messages = res.scan(/\+CMGL\:\s*?(\d+)\,\"\REC READ"\,\"(.+?)\"\,.*?\,\"(.+?)\".*?\n(.*)/)
        messages.each do |message|
          a = {
            phone_number: message[1],
            message: message[3].chomp!
          }
          result << a
        end
        result
      end
      
      def outbox
        res = read_message
        messages = res.scan(/\+CMGL\:\s*?(\d+)\,\"\STO SENT\"\,\"(.+?)\"\,\,.*?\n(.*)/)
        messages.each do |message|
          a = {
            phone_number: message[1],
            message: message[2].chomp!
          }
          result << a
        end
        result
      end
      
      def draft
        res = read_message
        messages = res.scan(/\+CMGL\:\s*?(\d+)\,\"\STO UNSENT\"\,\"(.+?)\"\,\,.*?\n(.*)/)
        messages.each do |message|
          a = {
            phone_number: message[1],
            message: message[2].chomp!
          }
          result << a
        end
        result
      end
    end
    
    private
    
    def read_message
      result = []
      modul.send_command("CMGF=1")
      sleep 1
      modul.send_command("CMGL=\"ALL\"")
      sleep 3
      modul_result
    end
    
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