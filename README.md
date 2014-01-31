# Logman

Logman is Web Console/API for gathering logs from various sources and analyzing them. Logs are saved to mongo database.

![](https://dl.dropboxusercontent.com/u/39131387/logman-b.png)

## Installation

Add this line to your application's Gemfile:

    gem 'logman', :git=>'git@github.com:saicoder/logman.git'

And then execute:

    $ bundle

Version of logman at Rubygems.org currently don't have dependencies defined, so best way to install it is over git

## Usage

Create rackup file `logman.ru` with content:

```ruby
require 'logman'

Logman.configure do |config|
  config.database_uri = 'mongodb://localhost/logman'
  
  config.log_writer = Logman::LogWriter
  config.web_console = Logman::WebConsole
end

run Logman::Server

```

Execute `rackup logman.ru` command 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
