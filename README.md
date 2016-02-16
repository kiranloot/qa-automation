# Lootcrate QA Automation - Cucumber

Our acceptance test automation written in cucubmer/capybara

More information Later...

## Installation

Install RVM (Directions [here](https://rvm.io/rvm/install))

Install Chromedriver (This enables framework to run an instance of Google Chrome)
Requires homebrew to install. Directions to install that are [here](http://brew.sh).
```console
brew install chromedriver
```

Fork the git repository, clone locally:

```console
git clone git@github.com:your_username/qa-automation.git
```

Ensure using Ruby v2.2.0:
```console
rvm info
```

Run the following command to install it and all dependent ruby gems:
```console
bundle install
```

If Bundler is not installed, run the following command:
```console
gem install bundler
```

## Cucumber Variables
There are certain variables that you can pass into a run to control where it run and how

#####SITE
`SITE = <qa,qa2,qa3,qa4,qa5,goliath,staging> (default = qa)`

Controls which environment you want to run the tests against

#####DRIVER
`DRIVER = <local,remote,appium> (default = local)`

Controls which driver you want to use

'local' => will launch each thread in a self contained selenium instance using the gem in the repo

'remote' => will launch tests against a selenium grid instance specified by REMOTE_URL (see below)

'appium' => will launch tests against a local appium server with default settings.  Works only with ios currently.  Run with the @mobile_ready tag (see below)

#####REMOTE_URL
`REMOTE_URL = <url_running_grid_hub) (default = http://127.0.0.1:4444/wd/hub)`

If using the DRIVER=remote option, this specifies the url that is running the hub.

#####BROWSER
`BROWSER = <chrome,ie,firefox,safari> (default = chrome)`

Specifies which browser to launch tests in.
 
NOTE - Only chrome is fully supported now.  Safari will work with tests tagged with @safari_ready only run serially.  Firefox and IE tests have not been fully vetted out at the time of writing.

## Running tests
In order to run tests, from the root directory, run:

`cucumber --tags @\<tags\> SITE=\<qa,qa2,goliath,staging\>`

To run the whole regression suite, run tests tagged with @ready. For instance:
```
cucumber --tags @ready SITE=qa2
```



You can also run tests in a specific feature file:
```shell
cucumber SITE=qa2 acceptance_tests/subscription_creation_1.feature
```



Or you can run one specific scenario in a feature file by specifying the line number of the Scenario in the file:
```shell
cucumber SITE=qa2 acceptance_tests/subscription_creation_1.feature:4
```



To run a full automation test suite, it's highly recommended you run tests in parallel to cut down on the amount of time a test run takes.
An example of the command to do so is below:
```shell
SITE=qa3 parallel_cucumber -o \'--tags @ready\' -n 8  acceptance_tests --serialize-stdout
```
The `-n` value can be adjusted if you want more or fewer instances of your browser running at the same time (8 has worked out for us, historically).
The `--tags @ready` keeps the suite focused on only scenarios that are marked as ready for use in the full test suite.

Mobile testing is supported for a handful of tests to date. To execute them will require setting up the Appium automated mobile testing framework and having XCode installed on your machine. Once those are set up, run the following to execute all mobile-ready tests:
```shell
cucumber SITE=qa DRIVER=appium --tags @mobile_ready
```


## After-Test Features
At the end of any test run, the results are printed to html files in the `/reports` folder. They are named `lastrun[x].html`. Each parallel instance will post its own html file, and the `[x]` will display the number for that particular thread. Feel free to browse them after a test run and find out what failed/succeeded.

In addition, There will be 'rerun[x].txt' files that will list files that list the scenarios that failed in a test run. To rerun those tests, run the following command (adjust SITE or other parameters as needed):
```shell
cucumber SITE=qa @reports/rerun[x].txt
```




## Contributors

* Chris Lee
* Kristopher Clemente
* Kiran Gajipara
* Jason Carter
* Thomas Lawler
