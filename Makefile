# Final build filename
APP=signoff

# Directories
BIN=node_modules/.bin
BOWER=bower_components
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

# Always run these tasks, regardless of file existence or mtime
.PHONY : all clean watch server css js optimise_images $(IMAGE_SOURCES)

# General

all: css js

clean:
	rm -rf $(CSS_TARGET) $(JS_TARGET)

watch:
	$(BIN)/wach -o "$(SASS)/**/*,$(JS)/**/*" make all --quiet

server:
	$(BIN)/http-server PUBLIC -p 8080 -e html -c-1

# CSS

css: $(CSS_TARGET)

$(CSS_TARGET): $(SASS_SOURCES)
	$(BIN)/node-sass $(SASS)/$(APP).scss $(CSS_TARGET)
	$(BIN)/autoprefixer --browsers "> 1%" $(CSS_TARGET)
	$(BIN)/csslint $(CSS_TARGET) --format=compact

# JS

js: $(JS_TARGET)

$(JS_TARGET): $(JS_SOURCES)
	$(BIN)/jshint $(JS_SOURCES)
	cat $(BOWER)/angular/angular.js $(JS)/$(APP).js > $(JS_TARGET)

# Images

optimise_images: $(IMAGE_SOURCES)

$(wildcard $(IMAGES)/**/*.png):
	$(BIN)/optipng-bin -o 5 -quiet $@

$(wildcard $(IMAGES)/**/*.jpg):
	$(BIN)/jpegtran-bin -optimize -outfile $@ $@