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
