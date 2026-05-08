# llama.cpp Custom Build

Build scripts and CI for [llama.cpp](https://github.com/ggml-org/llama.cpp) with specific branches/PRs that aren't yet merged into mainline.

Currently targets **PR #22673** (MTP — Multi-Token Prediction support), required to run models like [Qwen3.6-35B-A3B-MTP-GGUF](https://huggingface.co/havenoammo/Qwen3.6-35B-A3B-MTP-GGUF).

## Local Build

```bash
./build.sh                     # Default: PR #22673 (MTP)
./build.sh pull/22673/head     # Same as above
./build.sh main                # Latest main branch
./build.sh v1.2.3              # Specific tag
```

Requires `cmake` and Xcode command line tools. The built binary is at `llama.cpp/build/bin/llama-server`.

## GitHub Actions

The workflow can be triggered manually from the Actions tab:

- **release_tag**: Tag name for the release (e.g. `v0.1.0-mtp`)
- **llama_ref**: llama.cpp ref to build (default: `pull/22673/head`)

It builds `llama-server` for macOS ARM64 (Apple Silicon) with Metal and uploads it as a GitHub Release.

## Usage

```bash
./llama-server \
  -m /path/to/qwen3.6-35b-a3b-mtp.gguf \
  --spec-type mtp \
  --spec-draft-n-max 3
```
