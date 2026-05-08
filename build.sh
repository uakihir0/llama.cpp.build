#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
LLAMA_DIR="${SCRIPT_DIR}/llama.cpp"
PR_NUMBER=22673

if [ ! -d "${LLAMA_DIR}" ]; then
    echo "Cloning llama.cpp..."
    git clone https://github.com/ggml-org/llama.cpp.git "${LLAMA_DIR}"
fi

cd "${LLAMA_DIR}"

if ! git branch --list pr-${PR_NUMBER} | grep -q "pr-${PR_NUMBER}"; then
    echo "Fetching PR #${PR_NUMBER}..."
    git fetch origin "pull/${PR_NUMBER}/head:pr-${PR_NUMBER}"
    git merge --no-ff "pr-${PR_NUMBER}" -m "Merge PR #${PR_NUMBER}: llama + spec: MTP Support"
fi

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
