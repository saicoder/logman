# Logman

Logman is Web Console/API for gathering logs from various sources and analyzing them. 
Logs are saved to mongo database.

![](https://dl.dropboxusercontent.com/u/39131387/logman-c.png)

## Installation

Add this line to your application's Gemfile:

    gem 'logman'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install logman

## Usage

Create databse configuration file `database.yaml` with mongo connection settings:

```yaml
development:
  sessions:
    default:
      database: logman
      hosts:
        - localhost:27017

production: #example connection for Heroku and MongoHQ
  sessions:
    default:
      uri: <%= ENV['MONGOHQ_URL'] %>
      options:
        skip_version_check: true
        safe: true
```

Create rackup file `config.ru` with content:

```ruby
require 'logman'

Logman.configure

run Logman::Server
```

Execute `rackup config.ru` command 

## How to use it

Open console in web browser and create your account then create Bucket for your server or web app.  
Bucket is space for writing logs. Every bucket is basically mongo collection.   
To send logs to bucket you need bucket token. 

If you want to capture logs from Rails application you can use [Rails Logman](https://github.com/saicoder/logman_rails) gem.

To send logs manually make POST request to `http://logman_host:port/api/write?key=bucket_token` with JSON message in format:

```javascript
{
	
 	log_type: 1, 					//type of log: 1-error, 2-success, 3-warning,4-info
 	message: 'Err...', 				//log message
 	
 	//Optional parameters
 	data: {						//additional data
 		innerException: {message:'...'}    
 	},
 	datetime: '1-1-2013 10:00', 			//time when error occurred on server
 	data_type: '.net exception', 			//not used for now, but indicates 'data' field format
 	
 	sources: [{ 					//Name and IP of machine that generated an error, 
 		name: 'my server',			//if logman Proxy is used, it will append his hostname and ip
 		ip_address: '234.124.156.123'
 	}]
}

```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


