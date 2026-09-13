#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"
export PATH="/Library/TeX/texbin:$PATH"

if ! command -v pdflatex &>/dev/null; then
  echo "Erro: MacTeX não encontrado em /Library/TeX/texbin/"
  echo "Instale com: brew install --cask mactex"
  echo "Depois reinicie o terminal e rode: eval \"\$(/usr/libexec/path_helper)\""
  exit 1
fi

latexmk -pdf -interaction=nonstopmode artigo.tex
echo "PDF gerado: $(pwd)/artigo.pdf"
open artigo.pdf 2>/dev/null || true
