# Jekyll-Hashtags

>#hashtags support for you jekyll site. 

[![Gem Version](https://badge.fury.io/rb/jekyll-hashtags.svg)](http://badge.fury.io/rb/jekyll-hashtags)
[![Build Status](https://travis-ci.com/mynux/jekyll-hashtags.svg?branch=master)](https://travis-ci.com/mynux/jekyll-hashtags)

## Installation

Add this line to your application's Gemfile:

```ruby
group :jekyll_plugins do
  gem 'jekyll-hashtags'
end
```

And then execute:
```shell
    $ bundle
```
Or install it yourself as:
```shell
    $ gem install jekyll-hashtags
```
## Usage


Add the following to your site's _config.yml

```ruby
plugins:
  - jekyll-hashtags
```

Note: if jekyll --version is less than 3.5 use:

```ruby
gems:
  - jekyll-hashtags
```  
In any page or post, use #hashtags as you would normally, e.g.

>  Hey #AmazonGo, what do you think?

*to*

> Hey <a href="/tags/AmazonGo" target="_blank" class="hashtag">#AmazonGo</a>, what do you think?


## Configuration

  Have your own social network? No problem. We allow you to configure the base URL of all the hashtags.

  To change it, add the following to your Jekyll configuration:

  ```yml
 jekyll-hashtags:
   base_url: https://hengwei.me
 ```

  An example of Twitter hashtags using jekyll-hashtags:

  ```yml
 plugins:
   - jekyll-hashtags

 jekyll-hashtags:
   base_url: https://twitter.com/hashtag/
 ```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mynux/jekyll-hashtags.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
