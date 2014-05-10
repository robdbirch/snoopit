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
            -T, --tracking                   Enable log file tracking using file ./snoopit_db.json
            -f, --tracking-file file_name    Specify a different tracking file name and location instead of the default ./snoopit_db.json
            -j, --json                       Generate output in json
            -J, --pretty-json                Generate output in pretty json
            -N, --no-newline                 Do not output new line between found items
            -n, --enable-notifications       Enable notifications
            -l, --line-numbers               show line numbers
            -v, --verbose                    prints out file name, matched line number
            -h, --help


## Snooper Configuration
This is a JSON file which describes to the `Snooper` how to snoop around files and directories to find items of interest using regular expressions. It contains an array of files to snoop. Each file can be associated one or more regular expressions. Each regular expression behavior can be customized and each regular expression can be associated with zero or more event notifiers. The `Snooper` file also specifies notifier configurations and how to load custom notifiers.


        "snoopers" : [
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
                                    "notify" : {
                                        "email" : {
                                            "to" : "admin@noxaos.com"
                                        }
                                    }
                                }
                             ]
                        }
                     ],
        "notifiers" :
          {
              "load" : {
                  "Test Notifier Load" : {
                      "file" : "/Users/rbirch/Development/projects/snoopit/spec/support/test_notifier_load",
                      "class" : "TestNotifierLoad",
                      "config" : { }
                  }
              },
              "email" : {
                  "smtp-server" : "smtp.gmail.com",
                  "port" : 587,
                  "tls" : true,
                  "user" : "someone@gmail.com",
                  "password" : "apassword",
                  "authentication" : "login"
              }
          }


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

The above specification will snoop all files in directory `/opt/servers/app_server/log` with a suffix of `.log`

#### Defining Snooper Regular Expressions
Each `Snooper` has one or more regular expression specifications. This array of regular expressions are used to sniff through the files. These are identified as `Sniffers`.

##### Sniffer Attributes

* `comment`    Typically used by a `Notifier`, such as in the subject line in an email notifier.
* `regexp`     The value of this string is passed to ruby's [Regexp](http://www.ruby-doc.org/core-2.1.1/Regexp.html)
* `lines`
    * `before` Number of lines to print out before the matched line
    * `after`  Number of lines to print out after the matched line
* `notify`     This is a list of event notifiers to use when a line is matched

        "sniffers" : [
            {
                "comment" : "Bad status from server",
                "regexp" : "Non OK Status",
                "lines" : {
                    "before" : 2,
                    "after" : 2
                },
                "notify" : {
                    "email" : {
                       "to": [ "watcher@something.com", "admin@something.com" ],
                       "from" : "snooper@something.com"
                    }
                }
            }
         ]

## Notifiers
After a file is snooped by the `Snooper` any items matched a `Sniffer` regular expressions can be sent by specifying a notifier. Notifier's can be used to send  notifications, such as an email, text messages, or enqueue for, or call a another service to take action based on the matched event.

### Using a Notifier
Each `Sniffer` can use one or more notifiers. Notification parameters are specified for each `Sniffer` that uses a particular notifier. In the example above the `email` notifier parameters used are the `to` and `from` parameters.

### Configuring a Notifier for the Manager
Notifiers will most likely need some minimal configuration information. These notifier configurations are specified after the `snoopers` section of the `Snooper` configuration file.

       "notifiers" :
            {
                "email" : {
                    "smtp-server" : "smtp.gmail.com",
                    "port" : 587,
                    "user" : "someone@gmail.com",
                    "password" : "password",
                    "authentication" : "login"
                }
            }



### Email Notifier
The email notifier is a simple `SMTP` mail notification provider.

#### Email Notifier Sniffer Parameters
The following parameters can be used with the `email` notifier

* `to` Specifies who is to receive the email notification information. This can be a single string or an array

        "foo@bar.com" or [ "foo@bar.com", "bar@foo.com" ]


#### Email Notifier Configuration
The following configuration information is specified in the `notifiers` section of the `Snooper` configuration file.

* `email` Section name
* `smtp-server` SMTP sever name
* `port` SMTP port
* `user` User name
* `password` Password
* `authentication` Authentication type can be one of the following `plain`,`login`,`cram_md5`

### Stomp Notifier
Available soon.

### Redis Notifier
Available soon.

### HTTP Post
Available soon.

### Building Custom Notifiers
All Notifiers must inherit from the class `Snoopit::Notifier` and implement the `notify` method

      def notify(found, notify_params)
        raise NotImplementedError.new 'Notifier#notify'
      end

#### `notify` Parameters

* `found` is  a `hash` with the matched regular expression. It's what the `Snooper` sniffed out from the file.

          {
              comment: comment,
              file: file,
              before: [ lines before match ],
              match: matched_line,
              match_line_no: line_no_of_match,
              after: [ lines after match ]
          }

* `notify_params` These are the parameters defined for the notifier in the `Sniffer notifier`  section (e.g. to and from parameters for the email notifier)

### Dynamically Loading Custom Notifiers
To make a non default notifier available to the `Snooper` a notifier must be dynamically loaded. Specifying a `notifier` to be dynamically loaded is specified in the `notifiers` section of the `Snooper` configuration file.

        "notifiers" {
                        "load" : {
                            "My Custom Notifier" : {
                                "file" : "/opt/snooper/notifiers/my_custom_notifier",
                                "class" : "MyCustomNotifier",
                                "config" : { "param1": "configure_me" }
                            }
                        }
                    }

In the `notifiers Hash` in the `load Hash` add the following in `Custom Notifier Hash`

* A key with a descriptive unique name  `My Custom Notifier`
* `file` The path to the ruby file that contains the custom notifier class `"/opt/snooper/notifiers/my_custom_notifier"`
* `class` The class name of your notifier `MyCustomNotifier`
* `config` Any parameters needed to configure the custom notifier prior to generating notifications
    * Internally the `Snooper` will use a default initializer to create a custom notifier
        *  `MyCustomNotifier.new`
    * If there are `config` items then the `set_config` method is called on the the custom notifier to set the notifier's configuration


## File Tracking
Typically the `Snooper` is used for repeated invocations on a log file. This is typically done via `cron`. Enabling file tracking allows the `Snooper` to keep track of where it was in a file on it's last snoop of the file. Enabling file tracking prevents rereading the whole file and resending matched events. When file tracking is enabled using by the `-T` to `snoopit` the `Snooper` creates a `JSON` database in the directory where the `Snooper` was invoked. This file has the name `snoopit_db.json` The location of this file can be changed using the `-f` option of `snoopit`. If the `-f` option is used the `-T` is implied and does not need to be specified.


## Cron example


## History
Written this handy little utility too many times too count. From the ancient times via Rob Pikes and the gang's `sh`,`grep`, `awk`, `sed` and `mail` to Larry Wall's wonderful `perl` to the latest and best yet `ruby` from Matz.

        grep -H -n -B 2 -A 2 'Look for this' ./log/some.log | awk ... |  mail ...



## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
