.SUFFIXES: .js .pegjs .css .html .smcat .svg .png .jpg
PEGJS=node_modules/pegjs/bin/pegjs
MAKEDEPEND=node_modules/.bin/js-makedepend --output-to config/jsdependencies.mk --exclude "node_modules|docs"
WEBPACK=node_modules/.bin/webpack
HANDLEBARS=node_modules/.bin/handlebars

# dependencies
include config/jsdependencies.mk

GENERATED_SOURCES=src/parse/smcat-parser.js \
	src/render/dot/dot.states.template.js \
	src/render/dot/dot.template.js \
	src/render/smcat/smcat.template.js \
	src/render/html/HTMLTable.template.js \
	src/render/scxml/scxml.states.template.js \
	src/render/scxml/scxml.template.js \
	docs/index.html \
	docs/smcat-online-interpreter.min.js \
	docs/dev/index.html \
	docs/dev/smcat-online-interpreter.bundle.js \
	docs/dev/smcat-online-interpreter.bundle.js.map

# production rules
src/parse/%-parser.js: src/parse/peg/%-parser.pegjs
	$(PEGJS) --extra-options-file config/pegjs-config.json -o $@ $<

src/render/%.template.js: src/render/%.template.hbs
	$(HANDLEBARS) --commonjs handlebars/dist/handlebars.runtime -f $@ $<

docs/index.html: docs/index.hbs docs/smcat-online-interpreter.min.js docs/config/prod.json
	node utl/cutHandlebarCookie.js docs/config/prod.json < $< > $@

docs/dev/index.html: docs/index.hbs docs/config/dev.json
	node utl/cutHandlebarCookie.js docs/config/dev.json < $< > $@

docs/dev/smcat-online-interpreter.bundle.js: $(ONLINE_INTERPRETER_SOURCES)
	$(WEBPACK) --env dev --mode development --progress

docs/dev/smcat-online-interpreter.bundle.js.map: docs/dev/smcat-online-interpreter.bundle.js

docs/smcat-online-interpreter.min.js: $(ONLINE_INTERPRETER_SOURCES)
	$(WEBPACK) --env prod --mode production --progress

docs: $(GENERATED_SOURCES)

public:
	mkdir -p $@

public/samples:
	mkdir -p $@

public/%: docs/%
	cp $< $@

%.gz: %
	gzip --best --stdout $< > $@

# executable targets
depend:
	$(MAKEDEPEND) --system cjs src
	$(MAKEDEPEND) --append --system cjs test
	$(MAKEDEPEND) --append --system cjs --flat-define ONLINE_INTERPRETER_SOURCES docs/smcat-online-interpreter.js

clean:
	rm -rf $(GENERATED_SOURCES)
	rm -rf coverage
	rm -rf public

dev-build: src/index.js docs/dev/index.html docs/dev/smcat-online-interpreter.bundle.js

dist: dev-build docs/index.html docs/smcat-online-interpreter.min.js

pages: dist \
	public \
	public/index.html \
	public/index.html.gz \
	public/smcat-online-interpreter.min.js \
	public/smcat-online-interpreter.min.js.gz \
	public/samples \
	public/samples/cat.smcat \
	public/samples/cat.smcat.gz \
	public/samples/cheatsheet.smcat \
	public/samples/cheatsheet.smcat.gz \
	public/samples/empty.smcat \
	public/samples/karl.smcat \
	public/samples/karl.smcat.gz \
	public/samples/mediaplayer.smcat \
	public/samples/mediaplayer.smcat.gz \
	public/samples/on-off.smcat \
	public/samples/parallel.smcat \
	public/samples/parallel.smcat.gz \
	public/samples/PDSA.smcat \
	public/samples/PDSA.smcat.gz \
	public/samples/sprint-states.smcat \
	public/samples/sprint-states.smcat.gz

