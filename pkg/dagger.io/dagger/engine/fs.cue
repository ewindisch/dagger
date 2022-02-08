package engine

// Access the source directory for the current CUE package
// This may safely be called from any package
#Source: {
	$dagger: task: _name: "Source"

	// Relative path to source.
	path: string
	// Optionally exclude certain files
	include: [...string]
	// Optionally include certain files
	exclude: [...string]

	output: #FS
}

// Create one or multiple directory in a container
#Mkdir: {
	$dagger: task: _name: "Mkdir"

	// Container filesystem
	input: #FS

	// Path of the directory to create
	// It can be nested (e.g : "/foo" or "/foo/bar")
	path: string

	// Permissions of the directory
	permissions: *0o755 | int

	// If set, it creates parents' directory if they do not exist
	parents: *true | false

	// Modified filesystem
	output: #FS
}

#ReadFile: {
	$dagger: task: _name: "ReadFile"

	// Filesystem tree holding the file
	input: #FS
	// Path of the file to read
	path: string
	// Contents of the file
	contents: string
}

// Write a file to a filesystem tree, creating it if needed
#WriteFile: {
	$dagger: task: _name: "WriteFile"

	// Input filesystem tree
	input: #FS
	// Path of the file to write
	path: string
	// Contents to write
	contents: string
	// Permissions of the file
	permissions: *0o600 | int
	// Output filesystem tree
	output: #FS
}

// Produce an empty directory
#Scratch: #FS & {$dagger: fs: _id: null}

// Copy files from one FS tree to another
#Copy: {
	$dagger: task: _name: "Copy"
	// Input of the operation
	input: #FS
	// Contents to copy
	contents: #FS
	// Source path (optional)
	source: string | *"/"
	// Destination path (optional)
	dest: string | *"/"
	// Output of the operation
	output: #FS
}

#CopyInfo: {
	source: {
		root: #FS
		path: string | *"/"
	}
	dest: string
}

// Merge multiple FS trees into one
#Merge: {
	@dagger(notimplemented)
	$dagger: task: _name: "Merge"

	input: #FS
	layers: [...#CopyInfo]
	output: #FS
}
