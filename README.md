## Description
urls is a commandline bookmarking app that aims to make bookmarking fast, easy and customizable.
urls also lets you organize bookmarks by tags. Works only on ruby 1.9.

## Usage

```sh
# Comes with following commands
$ urls
Usage: urls [OPTIONS] COMMAND [ARGS]

Available commands:
  add   adds url with optional description and tags
  edit  edits urls in a file
  help  Displays help for a command
  list  list all urls or by a tag
  rm    removes url
  tags  List tags

Options:
  -h, --help  Displays this help message

# Optional description comes after url
$ urls add http://news.ycombinator.com time sink --tags funny
urls: Added http://news.ycombinator.com

$ urls list
+-----------------------------+-----------+-------+
| name                        | desc      | tags  |
+-----------------------------+-----------+-------+
| http://news.ycombinator.com | time sink | funny |
+-----------------------------+-----------+-------+
1 row in set

$ urls tags
funny
```

## Configuration

Custom config and additional commands can be defined in ~/.urlsrc:

```ruby
# Change database adapter to postgres
Urls.db = 'postgres://me:@localhost/my_db'

# Add `urls my_command` with a force option
class Urls::Runner
  option force: :boolean
  def my_command(options={})
  end
end
```

For full list of supported database adapters, [see here](https://github.com/datamapper/dm-core/wiki/Adapters).
To learn more about defining custom commands, [read about boson](https://github.com/cldwalker/boson#readme).

## Motivation
[tagtree](https://github.com/cldwalker/tag-tree) and its shortcomings. While it had wicked querying
capibilites, it was pretty unusable from the commandline. urls aims to change that and make this
very usable, from the commandline and browser.

## TODO
* Create additional plugin to give your urls a web interface
* Create additional plugin that let's you add bookmarks from your browser
* Allow tag storage be indepent of `tag`
