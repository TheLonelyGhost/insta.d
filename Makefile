PREFIX ?= /usr/local


$(PREFIX)/bin/instant.d:
	mkdir -p $(PREFIX)/bin
	cp ./bin/instant.d $(PREFIX)/bin/instant.d
	chmod a+x $(PREFIX)/bin/instant.d

$(PREFIX)/share/instant.d:
	mkdir -p $(PREFIX)/share/instant.d
	cp -a ./share/instant.d/* $(PREFIX)/share/instant.d/

.PHONY: install uninstall reinstall test clean all
install: $(PREFIX)/bin/instant.d $(PREFIX)/share/instant.d

uninstall:
	rm -rf $(PREFIX)/share/instant.d $(PREFIX)/bin/instant.d

reinstall: uninstall install

test:
	@# nothing to do here (yet)

clean:
	@# nothing to do here (yet)

all: clean test install
