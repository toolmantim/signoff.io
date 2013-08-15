# Final build filename
APP=signoff

# Source directories
SASS=sass
JS=javascripts

# Sources to depend on and watch
SASS_SOURCES=$(SASS)/**
JS_SOURCES=$(JS)/**

# Directories
BIN=node_modules/.bin
BOWER=bower_components
BUILD=build
DIST=public

all: $(DIST)/$(APP).css $(DIST)/$(APP).js

clean:
	rm -rf $(BUILD)

watch:
	$(BIN)/wach -o "$(JS)/**/*,$(SASS)/**/*" make all --quiet

server:
	$(BIN)/http-server public -p 8080 -e html -c-1

$(DIST)/$(APP).css: $(BUILD)/$(APP).css
	cp $(BUILD)/$(APP).css $(DIST)/$(APP).css

$(DIST)/$(APP).js: $(BUILD)/$(APP).js
	cp $(BUILD)/$(APP).js $(DIST)/$(APP).js

$(BUILD):
	mkdir $(BUILD)

$(BUILD)/$(APP).css: $(BUILD) $(SASS_SOURCES)
	$(BIN)/node-sass $(SASS)/$(APP).scss $(BUILD)/$(APP).css
	$(BIN)/autoprefixer --browsers "> 1%" $(BUILD)/$(APP).css
	$(BIN)/csslint $(BUILD)/$(APP).css --format=compact

$(BUILD)/$(APP).js: $(BUILD) $(JS_SOURCES)
	$(BIN)/jshint $(JS_SOURCES)
	cat $(BOWER)/angular/angular.js $(JS)/$(APP).js > $(BUILD)/$(APP).js
