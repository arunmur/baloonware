# baloonware

## How to run? ##

This was developed and tested in ruby version 2.1.2. It has .ruby-version set to 2.1.2, which will be picked up if rbenv is used.

To install rbenv, follow steps from [github/rbenv](https://github.com/sstephenson/rbenv)
To install 2.1.2 through rbenv,

    rbenv install 2.1.2

To run the generator, please perform

    ruby generate_data.rb

To run the processor, please perform

    ruby processor.rb

To run the specs, please perform

    bundle install
    bundle exec rspec spec

## Assumptions/Simplifications ##

* Dates are always in UTC.
* The location co-ordinates are considered as per a flat map and not for a globe.
* Sensor failures are not considered/handled.
* It is possible to read data one line at a time, without any in-app buffering.

## High level design overview ##

The ultimate goal of the program is to run through large number of data collected through the balloon and compute simple stats from them without keeping them in memory. The application has 2 layers.


    -----------------       -------------------------      -----------------
    | Parse Raw Data |  ==> | Normalise/convert Data | ==> |  Collect Stats |
    -----------------       -------------------------      -----------------

The application at any point in time will only keep the raw_data, raw_parsed_data, converted_data and all the stat objects in memory. We through away the data as soon as our operations are complete. The stat algorithm themselves are tail recursive and hence only one copy of the stat objects are maintained.
