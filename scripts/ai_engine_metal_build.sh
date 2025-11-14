#!/bin/bash
# set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
PROJECT_ROOT=$(cd "${SCRIPT_DIR}/.." && pwd)

BUILD_TYPE=Release

AI_ENGINE_DIR="${PROJECT_ROOT}/miloco_ai_engine/core"
# BUILD_DIR="${PROJECT_ROOT}/build/ai_engine"
BUILD_DIR="${PROJECT_ROOT}/build/ai_engine"
OUTPUT_DIR="${PROJECT_ROOT}/output"
RUNTIME_OUTPUT_DIR="/tmp/llama_runtime"  # 新增

rm -rf "${OUTPUT_DIR}"
mkdir -p "${BUILD_DIR}" "${OUTPUT_DIR}"

# macOS Metal build
cmake -S "${AI_ENGINE_DIR}" -B "${BUILD_DIR}" \
    -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
    -DCMAKE_RUNTIME_OUTPUT_DIRECTORY="${RUNTIME_OUTPUT_DIR}" \
    -DCMAKE_CXX_STANDARD=17 \  
    -DGGML_METAL=ON

cmake --build "${BUILD_DIR}" --target llama-mico -j"$(nproc)"
cmake --install "${BUILD_DIR}" --prefix "${OUTPUT_DIR}"

# delete runtime output dir
rm -rf "${RUNTIME_OUTPUT_DIR}"