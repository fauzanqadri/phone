# Phone

gem that interact to your usb to make a call, and SMS

## Installation

clone to your computer
plug your modem or phone into computer

And then execute:

	$ cd /your/foo/path/to/phone
    $ bundle install

## Usage

take a look to `/lib/config.yml`
example :

	- :NOKIAN70:
    	:device_path: /dev/cu.NokiaN70
	- :ZTEMF180:
		:device_path: /dev/cu.ZTEATPORT_
		
`yeah for now only testing on nix nux based`
		
add those configuration line to `config.yml`
then inside the phone directory hit

	$ rake console

now we can do like this
	 
	>> a = Phone::Nokian70::Sms.new
	>> a.create :phone_number => "081234567890", :message => "Hello World, this message create using ruby :)"
	>> b = Phone::Ztemf180::Sms.new
	>> b.create :phone_number => "081234567890", :message => "Hello World, this message create using ruby and another phone :)"
	
## Device testing
* ZTE MF180


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
