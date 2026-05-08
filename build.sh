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

echo "Fixing dylib rpaths..."
cd "${LLAMA_DIR}/build/bin"
for bin in llama-server *.dylib; do
    [ -f "$bin" ] || continue
    otool -l "$bin" | grep -A2 'cmd LC_RPATH' | grep 'path ' | awk '{print $2}' | while read -r rpath; do
        install_name_tool -delete_rpath "$rpath" "$bin" 2>/dev/null || true
    done
    install_name_tool -add_rpath @executable_path "$bin" 2>/dev/null || true
done
for dylib in *.dylib; do
    [ -f "$dylib" ] || continue
    install_name_tool -id "@rpath/$dylib" "$dylib"
done

echo ""
echo "Build complete: ${LLAMA_DIR}/build/bin/llama-server"
echo ""
echo "Usage:"
echo "  ${LLAMA_DIR}/build/bin/llama-server \\"
echo "    -m /path/to/model.gguf \\"
echo "    --spec-type mtp \\"
echo "    --spec-draft-n-max 3"
