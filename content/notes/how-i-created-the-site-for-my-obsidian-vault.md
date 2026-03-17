---
author: ["Oscar Marquez"]
title: "How I created the site for my Obsidian vault"
date: "2026-03-15"
tags:
  - obsidian
  - script
  - python
---
This site is created using very simple script that transforms notes with certain parameters defined in `build.py` into ready-to-publish notes. The site itself is quite simple in usage, it uses [hugo](https://gohugo.io/) with a slightly modified [hugo-PaperMod](https://github.com/adityatelange/hugo-PaperMod/tree/master) theme that just uses the transformed Markdown files into HTML.

`build.py` performs a simple regular expression to find `publish: true` inside my `Notes/` directory:
```python
HOME = Path.home()
VAULT = HOME / "notes"
NOTES = VAULT / "Notes"
DEST = VAULT / "site" / "content" / "notes"

for filepath in NOTES.rglob("*.md"):
    process_file(filepath)

def process_file(filepath):
    # ...
    frontmatter = re.sub(
        r"^publish:\s*true\s*\n?", "", frontmatter, flags=re.MULTILINE
    )
    # ...
```

The script will essentially grab all the Markdown files in `NOTES` and search for those that have `publish: true` in their frontmatter and perform some basic modifications like removing unwanted properties or transforming by references into their source URLs.

After the script runs through all the files inside my vault I have a `site` directory where I manage everything related to what you are seeing right now: the build script, `public/` files with what `hugo build` produces, and the basic structure of a `hugo` site (`static/`, `assets/`, `themes/`).

> You can find the public files in the repository I have available at GitHub: [vault](http://github.com/moxcz/vault).

In short this is what I do:
```sh
./build.py
hugo build
git add . && git commit && git push
rsync <...>
```

But to avoid doing this every time I have all those steps inside a `Makefile` that allows me to simply do:
```sh
make publish
```

Now all I have to do is to sit down, write a note I know will become publicly available and do `<C-t` and select my blog template:
```
---
publish: true
---
```

This is all I need. I could of course make it more sophisticated; I've seen some mental gardens that even show the famous Obsidian graph view, but all I want is some simple way to put my thoughts on the internet, and this does it for me.

