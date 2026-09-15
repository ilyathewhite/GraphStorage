# GraphStorage

GraphStorage is a small Swift package for storing graph-shaped data with typed node and edge payloads.

It provides:

- `StoredGraph`: a serializable graph model with metadata, nodes, and edges
- `GraphStorageCodec`: helpers for encoding and decoding compressed `.lzma` graph files

## Installation

Requires Swift 6.0 or later and builds in Swift 6 language mode.

```swift
.package(url: "https://github.com/ilyathewhite/GraphStorage.git", from: "1.0.0")
```

## Overview

`StoredGraph` stores:

- graph-level metadata as string key/value pairs
- nodes with stable ids, kinds, ordering, payload types, and encoded payloads
- edges with stable ids, source/target nodes, ordering, payload types, and encoded payloads

`GraphStorageCodec` provides compressed save/load helpers built on top of JSON encoding and LZMA compression.
