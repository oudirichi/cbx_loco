# CbxLoco

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cbx_loco'
```

And then execute:

```
rails generate cbx_loco:install
```

## Usage
```
- "rake i18n:extract" extracts assets from server and client code, and uploads them to Loco using the developer API.
- "rake i18n:import" Imports assets from Loco using developer API into server-specific files and client-specific files
```

CbxLoco requires configuration of a Loco API key configurable into cbx_loco initializer

## Development

After checking out the repo, run `bundle install`

## Configuration
- **api_key** - (String) ...
- **languages** - (Array) ...
- **file_formats** - (Hash) ...
- **i18n_files** - (Array) ..
- **on** - used to specify custom task to do before extraction or after importation

```ruby
 config.on :after_import do
   puts "do something awesome after import!"
 end

 config.on :before_extract do
   puts "do something else during extract!"
 end
```
## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/cognibox/cbx_loco.
