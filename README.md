[![Gem Version](https://badge.fury.io/rb/converge.png)](http://badge.fury.io/rb/converge)
[![Build Status](https://travis-ci.org/azanar/converge.png?branch=master)](https://travis-ci.org/azanar/converge)
[![Code Climate](https://codeclimate.com/github/azanar/converge.png)](https://codeclimate.com/github/azanar/converge)
[![Coverage Status](https://coveralls.io/repos/azanar/converge/badge.png?branch=master)](https://coveralls.io/r/azanar/converge?branch=master)
[![Dependency Status](https://gemnasium.com/azanar/converge.png)](https://gemnasium.com/azanar/converge)

# Converge

Data merger for relational databases.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'converge'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install converge

## Usage

Unless you are a database developer, you will want to use one of several Converge adapters for your particular database:

PostgreSQL  - [Converge-PG](http://github.com/azanar/converge-pg)
Redshift - [Converge-RS](http://github.com/azanar/converge-rs)

If your database isn't listed above. Please feel free to hack together an adapter, and let me know about it. :-)

```ruby
require 'converge'

config = {
    columns: %w{id name address},
    target_name: "my_table",
    staging_name "my_staging_table"
}

orm_model = MyModel

connection = Converge::Pg::Connection.new(orm_model.connection)

model = Converge::Model.new(config, orm_model)

staging_table = Converge::DB::Table::Staging.new(model)

target_table = Converge::DB::Table::Target.new(model)

merger = Converge::DB::Table::Merger.new(staging_table, connection)
merger.merge(target_table)
```

API Documentation
-------------

See [RubyDoc](http://rubydoc.info/github/azanar/converge/index)

Contributors
------------

See [Contributing](CONTRIBUTING.md) for details.

License
-------

&copy;2015 Ed Carrel. Released under the MIT License.

See [License](LICENSE) for details.
