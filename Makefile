#MARKDOWN=pandoc -f markdown-auto_identifiers --smart
#MARKDOWN=lowdown -D html-head-ids

all: index.md index.html

md:
	ls *.md \
	| grep -vx index.md \
	| sed 's/\.md$$/.html/' \
	| xargs make

# Convert Markdown to HTML, inserting <title> and <body>.
.SUFFIXES: .md .html
.md.html:
	( \
	echo '<!DOCTYPE html>' ; \
	echo '<html lang="en">' ; \
	echo '<head>' ; \
	echo '<meta charset="utf-8">' ; \
	grep '^# ' $< | markdown | sed 's/h1>/title>/g' ; \
	echo '<style type="text/css">' ; \
	echo 'body {background: #eddcc9; color: #131d28; font: 1em sans-serif; max-width: 45em; margin: auto;}' ; \
	echo 'p {hyphens: auto; line-height: 1.5; text-align: justify;}' ; \
	echo '</style>' ; \
	echo '</head>' ; \
	echo '<body>' ; \
	markdown $< ; \
	echo '</body>' ; \
	echo '</html>' ; \
	) >$@

# Generate index.md, which is then converted into index.html using the above rules.
# This de-duplicates the HTML generation code.
index.md: md
	( \
	echo '# The Testimony of Jesus' ; \
	echo ; \
	echo '"I am your fellow slave and a fellow slave of your brothers who have the testimony of Jesus.' ; \
	echo 'Worship God.' ; \
	echo 'For the testimony of Jesus is the spirit of the prophecy."' ; \
	echo '(Revelation 19:10)' ; \
	echo ; \
	grep -H '^# ' *.md \
	| grep -v index.md \
	| sort -r \
	| sed 's/\(.*\)\.md:# \(.*\)/* [\2](\1.html)/' ; \
	) >$@

clean:
	rm -f *.html index.md

.PHONY: all clean md
