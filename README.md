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

## Running tests
In order to run tests, from the root directory, run:

`cucumber --tags @\<tags\> SITE=\<qa,qa2,goliath,staging\>`

Running tests tagged with the ready flag against qa2
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
