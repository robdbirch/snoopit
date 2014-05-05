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
            -t, --template                   Generate and template snoopies.json file to stdout
            -j, --json                       Generate output in json
            -J, --pretty-json                Generate output in pretty json
            -N, --no-newline                 Do not output new line between found items
            -l, --line-numbers               show line numbers
            -v, --verbose                    prints out file name, matched line number
            -h, --help


## Snooper Configuration
This is a JSON file which describes to the `Snooper` how to snoop around files and directories on how to find items of interest using regular expressions. It contains an array of files to snoop. Each file can be associated one or more regular expressions. Each regular expression can be behavior customized and each regular expression can be associated with zero or event notifiers.


        [
            {
                "snoop": "/opt/servers/app_server/log/my_app_server.log"
                "sniffers" : [
                    {
                        "comment" : "Bad status from server",
                        "regexp" : "Non OK Status",
                        "lines" : {
                            "before" : 2,
                            "after" : 2
                        },
                        "notify_by" : {
                            "email" : {
                                "to" : "admin@noxaos.com"
                            }
                        }
                    }
                 ]
            }
        ]


### Snoopers
Each element in the `JSON` `array` is associated with either a file or a directory that will be snooped.

##### File Snoopers
Each file `Snooper` is associated with one file.

        [
            {
                "snoop": "/opt/servers/app_server/log/my_app_server.log"
            }
        ]

The above specification will snoop the file `/opt/servers/app_server/log/my_app_server.log`

##### Directory Snoopers
Each directory `Snooper` is associated with one directory. If the `glob` is not specified then every file in the directory is snooped. The `glob` string value is passed to Ruby's [`Dir.glob`](http://www.ruby-doc.org/core-2.1.1/Dir.html#method-c-glob)

        [
         { "dir" :
            {
              "path" : "/opt/servers/app_server/log",
              "glob" : "*.log"
            }
         }
        ]

The above specification will snoop all files in directory '/opt/servers/app_server/log` with a suffix of `.log`

#### Defining Snooper Regular Expressions
Each `Snooper` has one or more regular expression specifications. This array of regular expressions are used to sniff through the files. These are identified as `Sniffers`.

##### Sniffer Attributes

* `comment`    Typically used by a `Notifier`, such as in the subject line in an email notifier.
* `regexp`     The value of this string is passed to ruby's [Regexp](http://www.ruby-doc.org/core-2.1.1/Regexp.html)
* `lines`
    * `before` Number of lines to print out before the matched line
    * `after`  Number of lines to print out after the matched line
* `notify_by`  This is a list of event notifiers to use when a line is matched

        "sniffers" : [
            {
                "comment" : "Bad status from server",
                "regexp" : "Non OK Status",
                "lines" : {
                    "before" : 2,
                    "after" : 2
                },
                "notify_by" : {
                    "email" : {
                        "to" : "admin@noxaos.com"
                    }
                }
            }
         ]

## Notifiers

### Using a Notifier

### Configuring a Notifier for the Manager

### Configuring a Notifier for a Snooper

### Building Notifiers

### Registering Notifiers

### Dynamically Loading Notifiers


## History
Written this handy little utility too many times too count. From the ancient times via Rob Pikes and the gang's `sh`,`grep`, `awk`, `sed` and `mail` to Larry Wall's wonderful `perl` to the latest and best yet `ruby` from Matz.

        grep -H -n -B 2 -A 2 'Look for this' ./log/some.log | awk ... |  mail ...



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
