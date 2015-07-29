# Lootcrate QA Automation - Cucumber

Our acceptance test automation written in cucubmer/capybara

More information Later...

## Installation

Fork the repository, clone locally:

```console
git clone git@github.com:your_username/qa-automation.git
```

Ensure using Ruby v2.2.0

Run the following command to install it:

```console
bundle install
```

## Running tests
In order to run tests, from the root directory, run:

cucumber --tags @\<tags\> SITE=\<qa,qa2,goliath,staging\>

Running tests tagged with the ready flag against qa2
```
cucumber --tags @ready SITE=qa2
```

## Contributors

* Chris Lee
* Kristopher Clemente
* Kiran Gajipara
* Jason Carter
