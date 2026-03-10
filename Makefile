.PHONY: export build serve clean

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
	git push
