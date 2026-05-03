.PHONY: export build serve clean
include .env

build:
	rm -rf public
	mkdir -p public
	cp -r site-home/. public/
	hugo --config hugo.toml,hugo.blog.toml --cleanDestinationDir

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
	rsync -avz public compose.yaml nginx.conf ${REMOTE_DIR}

send: build
	rsync -avz .env public compose.yaml nginx.conf ${REMOTE_DIR}
