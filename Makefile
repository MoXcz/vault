.PHONY: export build serve clean
include .env

build:
	hugo --cleanDestinationDir

serve:
	hugo server -D

clean:
	rm -rf public

export:
	./build.py

publish: build
	git add . && \
	git commit -m "update $$(date '+%Y-%m-%d')" || true && \
	git push && \
	rsync -avz ~/notes/site/public/ ${REMOTE_DIR}

send: build
	rsync -avz ~/notes/site/public/ ${REMOTE_DIR}
