package main

import (
	"dagger.io/dagger"
)

dagger.#Plan & {
	actions: {
		image: dagger.#Pull & {
			source: "alpine:3.15.0@sha256:e7d88de73db3d3fd9b2d63aa7f447a10fd0220b7cbf39803c803f2af9ba256b3"
		}

		mkdir: dagger.#Mkdir & {
			input: image.output
			path:  "/test/foo"
		}

		writeChecker: dagger.#WriteFile & {
			input:       mkdir.output
			path:        "/test/foo/hello"
			contents:    "world"
			permissions: 0o700
		}

		subdir: dagger.#Subdir & {
			input: writeChecker.output
			path:  "/directorynotfound"
		}

		verify: dagger.#Exec & {
			input: image.output
			mounts: fs: {
				dest:     "/target"
				contents: subdir.output
			}
			args: [
				"sh", "-c",
				#"""
					test $(ls /target | wc -l) = 1
					"""#,
			]
		}
	}
}
