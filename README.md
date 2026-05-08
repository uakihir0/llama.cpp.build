# llama.cpp Custom Build

Build scripts and CI for creating [llama.cpp](https://github.com/ggml-org/llama.cpp) binaries from any branch, tag, or unmerged PR.

Useful when you need features that haven't been released yet (e.g. experimental speculative decoding methods, new model support, etc.).

## Local Build

```bash
./build.sh                     # Default: pull/22673/head
./build.sh pull/22673/head     # Specific PR
./build.sh main                # Latest main branch
./build.sh v1.2.3              # Specific tag
```

Requires `cmake` and Xcode command line tools. The built binary is at `llama.cpp/build/bin/llama-server`.

## GitHub Actions

The workflow can be triggered manually from the Actions tab:

- **release_tag**: Tag name for the release (e.g. `v0.1.0`)
- **llama_ref**: llama.cpp ref to build — branch, tag, or PR (default: `pull/22673/head`)

It builds `llama-server` for macOS ARM64 (Apple Silicon) with Metal and uploads it as a GitHub Release.

## Example

```bash
./llama-server \
  -m /path/to/model.gguf \
  --spec-type mtp \
  --spec-draft-n-max 3
```
