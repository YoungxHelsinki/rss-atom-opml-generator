#!/usr/bin/ruby -w

require 'feedjira'
# url_hs = "http://www.hs.fi/rss/?osastot=kotimaa"
# feed_hs = Feedjira::Feed.fetch_and_parse url_hs


=begin
RSS/Atom aggregator

1. Read file given as a parameter. For each line (an url):
2. Check the url point to a valid rss/atom feed
3. Get the feed title and description. These might be nil,
   if so replace them with "No title" and "No description".
4. Write an opml file with item for each url/title/description.

Example opml file
<?xml version="1.0" encoding="utf-8" ?>
<opml version="1.1">
<head>
<title>Generated by Seyoung</title>
<dateCreated>Sat, 05 Dec 2015 11:54:16 +0100</dateCreated>
</head>
<body>
<outline title="www.hs.fi/rss/?osastot=politiikka" text="www.hs.fi/rss/?osastot=politiikka" type="rss" xmlUrl="http://www.hs.fi/rss/?osastot=politiikka" />
</body></opml>

Ignore invalid urls and report them to a user.
Definition of invalid urls:
  1.Non-existing urls
  2.Invalid urls. ex) missing http://

You can read the whole file to ram and keep all urls,
titles and descriptions in ram until you write the opml.
Or you can read the file line by line and add items to the opml as you go.
=end

def write_opml(entry, type, save_path="")
    opml = "<?xml version='1.0' encoding='utf-8' ?>
    <opml version='1.1'>
    <head>
    <title>#{entry.title}</title>
    <dateCreated>#{entry.published}</dateCreated>
    </head>
    <body>
    <outline title=#{entry.title} text=#{entry.title} type=#{type} xmlUrl=#{entry.url} />
    </body></opml>"

    file_name = save_path + entry.title + ".opml"
    File.write(file_name, opml)
end

def get_feed_type(url)
    if url.include? "rss"
        return "rss"
    else
        return "atom"
    end
end

def parse_url(url, save_path)
    feed = Feedjira::Feed.fetch_and_parse url
    type = get_feed_type feed.url

    feed.entries.each do |entry|
        write_opml entry, type, save_path
    end
end


def read_file(fr_name, save_path)
    File.foreach(fr_name) do |url|
        parse_url url, save_path
    end
end


def main(fr_name, save_path="")
    read_file(fr_name, save_path)
end


main("dummy_urls.txt", "../opml/")
