package main

import (
	"dagger.io/dagger"
)

dagger.#Plan & {
	actions: {
		image: dagger.#Pull & {
			source: "alpine:3.15.0@sha256:e7d88de73db3d3fd9b2d63aa7f447a10fd0220b7cbf39803c803f2af9ba256b3"
		}

		exec: dagger.#Exec & {
			input: image.output
			args: [
				"sh", "-c",
				#"""
					echo -n hello world > /output.txt
					"""#,
			]
		}

		verify_file: dagger.#ReadFile & {
			input: exec.output
			path:  "/output.txt"
		} & {
			// assert result
			contents: "hello world"
		}

		copy: dagger.#Copy & {
			input:    image.output
			contents: exec.output
			source:   "/output.txt"
			dest:     "/output.txt"
		}

		verify_copy: dagger.#ReadFile & {
			input: copy.output
			path:  "/output.txt"
		} & {
			// assert result
			contents: "hello world"
		}
	}
}
