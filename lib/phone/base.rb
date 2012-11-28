module Phone
  
  class FailedToCreateSms < Exception;  end
  class FailedToSendSms < Exception;  end
  class FailedToDeleteSms < Exception;  end
  class MessagesEmpty < Exception;  end
  class Unknown < Exception;  end
  
  class << self
    #attr_accessor :device_path, :loader_command
    
    
    def configure
      config = YAML.load_file "#{Phone::root}/config.yml"
      config.each do |conf|        
        conf.each do |key, value|
          #Phone.device_path[key.to_s.capitalize] = 
          #Phone.loader_command[key.to_s.capitalize] = value[:loader_command]
          module_name = key.to_s.capitalize
          modul = self.const_set(module_name, Module.new)
          modul.module_eval do
            class << self 
              attr_accessor :serialport, :loader_command
                            
              def send_loader_command
                self.send_command(@loader_command)
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
            self.serialport = SerialPort.new(value[:device_path],"115200".to_i)
            self.loader_command = value[:loader_command]
            self.serialport.read_timeout = 300            
            self.send_loader_command unless value[:loader_command].nil?         
            klass = self.const_set("Sms",Class.new(Phone::Message))
          end            
        end
      end
    end    
  end
end

