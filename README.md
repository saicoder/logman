# Logman

Logman is Web Console/API for gathering logs from various sources and analyzing them. Logs are saved to mongo database.

## Installation

Add this line to your application's Gemfile:

    gem 'logman'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install logman

## Usage

Create rackup file `config.ru` with content:

```ruby
require 'logman'

Logman.configure do |config|
  config.database_uri = 'mongodb://localhost/logman'
  
  config.log_writer = Logman::LogWriter
  config.web_console = Logman::WebConsole
end

run Logman::Server

```

Execute `rackup -p 3000` 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
