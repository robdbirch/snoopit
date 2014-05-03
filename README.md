# Snoopit

Simple tool for monitoring process log files for specified events and then generating  a basic notification.

## Installation

Add this line to your application's Gemfile:

    gem 'snoopit'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install snoopit

## Usage
Typical use is via the command line with a JSON specification file.

        Usage: snooper [options]
            -s, --snoopers snoopies.json     File contains one or more regular expressions to locate a line of interest in a file
            -t, --template                   Generate and template json file to stdout
            -N, --no-newline                 Do not output new line between found items
            -l, --line-numbers               show line numbers
            -v, --verbose                    prints out file name, matched line number
            -h, --help


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
