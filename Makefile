.PHONY: help install install-venv install-foundation6 clean delpyc demo-build demo-server demo-clean demo-watcher github-build github-server github-clean release

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo
	@echo "  install              -- to proceed to a new install of this project. Will require 'git' client. Use clean command before if you want to reset a current install."
	@echo "  install-venv         -- to install the Python virtual environment. Will require 'virtualenv'."
	@echo "  install-foundation6  -- to install last Foundation6 sources. Will require 'wget' and 'bower'."
	@echo
	@echo "  demo-build           -- to build demonstration site in development env."
	@echo "  demo-server          -- to start demonstration site server with CherryPie."
	@echo "  demo-watcher         -- to start watchdog on sources in development env."
	@echo "  demo-clean           -- to clean builded HTML and assets from development env."
	@echo
	@echo "  github-build         -- to build demonstration site for Github site."
	@echo "  github-server        -- to start demonstration site server with CherryPie for Github site."
	@echo "  github-clean         -- to clean builded HTML and assets from Github site."
	@echo
	@echo "  clean                -- to clean your local repository from all installed stuff."
	@echo "  delpyc               -- to remove all *.pyc files, this is recursive from the current directory."
	@echo

delpyc:
	find . -name "*\.pyc"|xargs rm -f

clean-foundation6:
	rm -Rf foundation-sites-6.3.1
	rm -Rf sources/js/foundation6/foundation
	rm -Rf sources/js/foundation6/vendor/*.js

demo-clean:
	rm -Rf project/_build project/.webassets-cache

clean: delpyc demo-clean github-clean clean-foundation6
	rm -Rf bin include lib local share pip-selfcheck.json

install: install-venv install-foundation6

install-venv:
	virtualenv --no-site-packages --setuptools .
	bin/pip install -r requirements/dev.txt
	@echo "Install done. You should execute 'bin/activate' to start environment."

install-foundation6: clean-foundation6
	@echo "* Download Foundation 6.3.1 archive;"
	wget https://github.com/zurb/foundation-sites/archive/6.3.1.tar.gz
	@echo "* Open archive;"
	tar xvzf 6.3.1.tar.gz
	@echo "* Delete archive;"
	rm -Rf 6.3.1.tar.gz
	@echo "* Use 'bower' to get Foundation dependencies"
	cd requirements/foundation6 && bower install
	@echo "* Link Foundation Javascript files into project sources"
	cd sources/js/foundation6 && ln -s ../../../foundation-sites-6.3.1/dist/js foundation
	cd sources/js/foundation6/vendor && ln -s ../../../../foundation-sites-6.3.1/vendor/jquery/dist/jquery.js
	cd sources/js/foundation6/vendor && ln -s ../../../../foundation-sites-6.3.1/vendor/modernizr/modernizr.js
	cd sources/js/foundation6/vendor && ln -s ../../../../foundation-sites-6.3.1/vendor/jquery.cookie/jquery.cookie.js
	cd sources/js/foundation6/vendor && ln -s ../../../../foundation-sites-6.3.1/vendor/what-input/dist/what-input.js

demo-build: demo-clean
	cd project && ../bin/optimus-cli build

demo-server:
	cd project && ../bin/optimus-cli runserver 0.0.0.0:8001

demo-watcher:
	cd project && ../bin/optimus-cli watch

prod-build:
	rm -Rf _build/prod
	rm -Rf .webassets-cache
	cd project && ../bin/optimus-cli build --settings prod_settings

github-clean:
	rm -Rf docs
	rm -Rf .webassets-cache

github-build: github-clean
	cd project && ../bin/optimus-cli build --settings githubpages_settings

github-server:
	cd project && ../bin/optimus-cli runserver 0.0.0.0:8001 --settings githubpages_settings
