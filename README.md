# SinatraBoard

So I've been charged with training Zyber17 in the ways of Ruby web development,
so I thought it'd be neat to reimplement his pet project [Statboard][1] in
Ruby (specifically, Sinatra this time).

## What's Statboard?

The idea as it stands now is a small web app that runs on the user's computer,
regularly checking up on social networks and posting that data in a clean,
easy-to-read format. So, a widget for Twitter followers, Reddit karma,
StackOverflow reputation, etc., regularly reloading with the latest data.

## What's different about SinatraBoard?

Well, for starters, this version doesn't regularly reload with the latest data.
Since this was just a one-evening project, I opted to settle for simply
rendering the HTML. If this were actually meant to turn into something, the
code is organized in such a way that it wouldn't be a big deal to output the
panes as JSON, instead, and have them load via AJAX.

This version also supports links in the widget headers, and I happen to think
that the pane API is much easier to use :) (Wrote up that Github followers
pane, remote API call and all, in under 3 minutes. Boo ya.)

## How do I get this running?

Well, if all you want to know how it looks, I have a version configured for me
[running on Heroku][2]. If you'd like to run it yourself, pull the repository
and run it as you'd run any other Rack-based app. For instance, you could use
the `thin` gem.

    cd /path/to/app
    thin start

Also, don't forget to make sure you have all the gems specific to this
application:

    cd /path/to/app
    bundle install

Once things are up and running, it's easy-peasy to go into `/config/panes` and
change around the relevant usernames, and it's also easy to change
`/config/pane_order.yml` as you'd expect.

## So, if I want to learn from this code, where should I look?

Well, I think the real beauty of this project is that, even if it's ugly in
parts due to all that metaprogramming, it allows for very pretty pane code,
which is kinda the point: SinatraBoard is supposed to allow the panes to shine
and, for the most part, stay out of the way. By making the panes super-easy to
create, it does its job well.

One thing to take note of is the separation of concepts. Even though, in this
case, we're only ever going to have one set of config variables, the Pane class
and all the code in `/panes` is totally prepared to have multiple users, since
the config is only passed in when we actually initialize the pane objects on
each request. It'd still be a big job, but the existing infrastructure would
not get in the way of expanding SinatraBoard into a multi-user web app.

Anyway. I happen to think that `/lib/pane.rb` and `/lib/resource.rb` are pretty
good reads, since they build powerful APIs while still keeping things
relatively simple. Tell me what you think.

## How can I create a pane?

Glad you asked! The API is simple, and the examples in /panes really should be
enough. But here goes:

A pane class lives in /panes, and inherits from `Pane`. You may also create a
folder of the same name as your `.rb` file, the contents of which will be
loaded after your main pane file.

A pane instance has the instance method `config`, which, in this case, holds
the unserialized contents of `/config/[pane_name].yml`.

Here are the class methods that `Pane` offers:

* `title`: The title for the pane, which appears in big letters at the top.
  You can pass either a string or a block. In this method, as in all others
  that support both strings and blocks, the block will be evaluated on page
  load within the context of that `Pane` instance. (So, it has access to
  `config` and any instance methods you may create.)
* `link`: The URL to which the title should link. Accepts a string or block,
  and is optional.
* `stat`: The first parameter is the label for what this statistic represents
  (e.g. "followers"), and the block should return the value (e.g. 42). You may
  provide more that one statistic. The label may be omitted; however, at this
  time, you cannot provide more than one unlabeled statistic.

You'll also notice that some of the included examples use a custom `User` class
that inherits from `Resource`. `Resource` is designed to make it easier to
represent a remote resource to be accessed over HTTP. It has `HTTParty` mixed
in, so supports `format`, `base_uri`, etc., and also offers some shortcuts:

* `source`: Where the resource lives. `base_uri` + `source` = full URL. Takes
  either a string or a block.
* `query`: The query to append to the URL. So, if you would type
  `/users.json?id=1` in your browser, the query would be `{:id => 1}`.
  Similarly to the string/block methods, you may pass either a hash or a block
  that returns a hash.
* `scope`: If the data you want actually lives a few keys deep in the JSON
  response, provide the wrapping keys here. For example, if the API returns
  `{"user" => {"id" => 1, "name" => "Matchu"}}`, running `scope "user"` would
  make the resource's `data` method return `{"id" => 1, "name" => "Matchu"}`.
* `attr_resource`: Creates methods with the given names to refer to the given
  keys in the `data` method.

        attr_resource :name
        # is equivalent to
        def name
          data['name']
        end

`source`, `query`, and `scope` all help define what goes on in the automagic
`data` method, which takes care of a lot of the heavy lifting and error
handling for you. If those three methods (and HTTParty's `format`, `base_uri`,
etc.) are set correctly, `data` should return *exactly* the data you're
interested in.

Of course, it's best to learn by example. `/panes/today.rb` is a very simple
example, and `/panes/reddit.rb` is only slightly more complicated, but
significantly more powerful.

Anyway. Have fun browsing, and enjoy :)
—Matchu

[1]: http://zyber17.com/statboard/
[2]: http://sinatraboard.heroku.com/

