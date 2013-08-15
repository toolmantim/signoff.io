# Final build filename
APP=signoff

# Directories
BIN=node_modules/.bin
BOWER=bower_components
BUILD=build
PUBLIC=public

# Source directories
SASS=sass
JS=javascripts
IMAGES=$(PUBLIC)/images

# Sources to depend on and watch
SASS_SOURCES=$(wildcard $(SASS)/**/*)
JS_SOURCES=$(wildcard $(JS)/**/*)
IMAGE_SOURCES=$(wildcard $(IMAGES)/**/*)

# The two big targets
CSS_TARGET=$(PUBLIC)/$(APP).css
JS_TARGET=$(PUBLIC)/$(APP).js


.PHONY : all css js optimise_images $(IMAGE_SOURCES) clean watch server

all: css js

css: $(CSS_TARGET)

js: $(JS_TARGET)

optimise_images: $(IMAGE_SOURCES)

clean:
	rm -rf $(BUILD) $(CSS_TARGET) $(JS_TARGET)

watch:
	$(BIN)/wach -o "$(SASS)/**/*,$(JS)/**/*" make all --quiet

server:
	$(BIN)/http-server PUBLIC -p 8080 -e html -c-1

# Pre-reqs

$(BUILD):
	mkdir $(BUILD)

# CSS

$(CSS_TARGET): $(BUILD)/$(APP).css
	cp $(BUILD)/$(APP).css $(PUBLIC)/$(APP).css

$(BUILD)/$(APP).css: $(SASS_SOURCES) | $(BUILD)
	$(BIN)/node-sass $(SASS)/$(APP).scss $(BUILD)/$(APP).css
	$(BIN)/autoprefixer --browsers "> 1%" $(BUILD)/$(APP).css
	$(BIN)/csslint $(BUILD)/$(APP).css --format=compact

# JS

$(JS_TARGET): $(BUILD)/$(APP).js
	cp $(BUILD)/$(APP).js $(PUBLIC)/$(APP).js

$(BUILD)/$(APP).js: $(JS_SOURCES) | $(BUILD)
	$(BIN)/jshint $(JS_SOURCES)
	cat $(BOWER)/angular/angular.js $(JS)/$(APP).js > $(BUILD)/$(APP).js

# Images

$(wildcard $(IMAGES)/**/*.png):
	$(BIN)/optipng-bin -o 5 -quiet $@

$(wildcard $(IMAGES)/**/*.jpg):
	$(BIN)/jpegtran-bin -optimize -outfile $@ $@