ENVIRONMENT := nikola/
PORT ?= 7777

.PHONY: default $(ENVIRONMENT) clean setup help build serve post sync

default: help

$(ENVIRONMENT):
	virtualenv -p python3 "$@"

clean:
	rm -rf "$(ENVIRONMENT)"

setup:
	@echo "make $(ENVIRONMENT);"
	@echo "source $(ENVIRONMENT)bin/activate;"
	@echo "alias python=python3"
	@echo "python3 -mpip install --upgrade pip setuptools wheel Nikola[extras] Nikola[plugins] pygments-style-spacemacs"
	@echo "nikola subtheme -s superhero"
	@echo "pygmentize -S spacemacs-light -a .highlight -f html > files/assets/css/custom.css"


help:
	@echo "'eval \$$(make setup)': Setup Nikola environment"
	@echo "'make serve': Start a local webserver (on $(PORT) for viewing posts before publishing"
	@echo "'make post': Write a new post"

build:
	@nikola build

rebuild:
	@nikola build -a

serve: build
	@nikola serve -p $(PORT)

post:
	@nikola new_post -1 -f orgmode

page:
	@nikola new_post -p -1 -f orgmode

sync: build
	@rsync -av output/ jamesaimonetti.com:~/local/var/www/http-tailrecursivefarm.com
