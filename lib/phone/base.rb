module Phone
  
  class FailedToCreateSms < Exception;  end
  class FailedToSendSms < Exception;  end
  class FailedToDeleteSms < Exception;  end
  class MessagesEmpty < Exception;  end
  class Unknown < Exception;  end
  
  class << self
    attr_accessor :device_path, :loader_command   
    def configure
      @device_path = {}
      @loader_command = {}
      config = YAML.load_file "#{Phone::root}/config.yml"
      config.each do |conf|        
        conf.each do |key, value|
          Phone.device_path[key.to_s.capitalize] = value[:device_path]
          Phone.loader_command[key.to_s.capitalize] = value[:loader_command]
          module_name = key.to_s.capitalize
          modul = self.const_set(module_name, Module.new)
          modul.class_eval do
            class << self
              attr_accessor :serialport
              
              def configure
                identifier = self.to_s.split('::')
                self.serialport = SerialPort.new(Phone.device_path[identifier[1]],"115200".to_i)
                self.send_command("#{Phone.loader_command[identifier[1]]}") unless Phone.loader_command[identifier[1]].nil?
                self.serialport.read_timeout = 300
              end
              
              def send_command(command)
                self.serialport.write("AT+#{command}\r")
              end
    
              def send_text(text)
                self.serialport.write("#{text}")
              end
    
              def result
                self.serialport.read
              end
    
              def close
                self.serialport.close
              end
            end
            
            self.const_set("Sms",Class.new(SortMessageService))
          end            
        end
      end
    end    
  end
end

