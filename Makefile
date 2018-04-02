PREFIX ?= /usr/local


$(PREFIX)/bin/instant.d:
	mkdir -p $(PREFIX)/bin
	cp ./bin/instant.d $(PREFIX)/bin/instant.d
	chmod a+x $(PREFIX)/bin/instant.d

$(PREFIX)/share/instant.d:
	mkdir -p $(PREFIX)/share/instant.d
	cp -a ./share/instant.d/* $(PREFIX)/share/instant.d/

.PHONY: install uninstall test clean all
install: $(PREFIX)/bin/instant.d $(PREFIX)/share/instant.d

uninstall:
	rm -rf $(PREFIX)/share/instant.d $(PREFIX)/bin/instant.d

test:

clean:

all: clean test install
