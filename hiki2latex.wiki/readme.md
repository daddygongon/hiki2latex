# Hiki2latex
convert hikidoc text to latex format.

## Installation
Add this line to your application's Gemfile:
```ruby
gem 'hiki2latex'
```
And then execute:
```
$ bundle
```
Or install it yourself as:
```
$ gem install hiki2latex
```

## Usage
Use as a gem library:
```ruby
    require 'hiki2latex'
    
    puts HikiDoc.to_latex(File.read(ARGV[0]),{:level=>@level,:listings=>@listings})
```

or as a command line tool:

<dl>
<dt>Usage</dt><dd> hiki2latex [options] FILE</dd>
</dl>

```
> hiki2latex --pre PRICM_preamble.tex --post biblio.tex -p test.hiki > test.tex
> hiki2latex --listings --post post.tex -p ./test.hiki > test.tex
```

| option | operation|
|:----|:----|
|    -v, --version     |           show program Version.|
|    -l, --level VALUE |               set Level for output section.|
|    -p, --plain FILE  |               make Plain document.|
|    -b, --bare FILE   |               make Bare document.|
|        --head FILE   |               put headers of maketitle file.|
|        --pre FILE    |               put preamble file.|
|        --post FILE   |               put post file.|
|        --listings    |               use listings.sty for preformat with style.|


## Development
After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. Run `bundle exec hiki2latex` to use the gem in this directory, ignoring other installed copies of this gem.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing
Bug reports and pull requests are welcome on GitHub at https://github.com/daddygongon/hiki2latex. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
