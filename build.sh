#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LLAMA_DIR="${SCRIPT_DIR}/llama.cpp"
LLAMA_REF="${1:-pull/22673/head}"

if [ ! -d "${LLAMA_DIR}" ]; then
    echo "Cloning llama.cpp..."
    git clone https://github.com/ggml-org/llama.cpp.git "${LLAMA_DIR}"
fi

cd "${LLAMA_DIR}"

echo "Checking out ref: ${LLAMA_REF}"
git fetch origin "${LLAMA_REF}:target-ref"
git checkout target-ref

echo "Configuring build (Metal)..."
cmake -B build -DGGML_METAL=ON

echo "Building llama-server..."
cmake --build build --config Release --target llama-server -j"$(sysctl -n hw.ncpu)"

echo ""
echo "Build complete: ${LLAMA_DIR}/build/bin/llama-server"
echo ""
echo "Usage:"
echo "  ${LLAMA_DIR}/build/bin/llama-server \\"
echo "    -m /path/to/model.gguf \\"
echo "    --spec-type mtp \\"
echo "    --spec-draft-n-max 3"
