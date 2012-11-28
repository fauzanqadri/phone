# Phone

gem that interact to your usb-modem/phone to make a call, and SMS

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
		:loader_command: ZOPRT=5		
`yeah for now only testing on nix nux based`		
add those configuration line to `config.yml`
then inside the phone directory hit
	$ rake console
for sending message: 
now we can do like this	 
	>> a = Phone::Nokian70::Sms.new(:phone_number => "081234567890", :message => "Hello World, this message create using ruby :)")
	>> a.send
`inbox, outbox and draft are not implement yet`
## Device testing

* ZTE MF180

## Requirements

* `Ruby 1.9.3`
* `serialport gem`
* `ActiveSpport gem`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
