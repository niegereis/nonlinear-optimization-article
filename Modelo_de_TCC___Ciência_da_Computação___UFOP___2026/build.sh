#!/usr/bin/env bash
# Compila a monografia completa e as entregas, colocando os PDFs em Entregas/.
# Uso: ./build.sh            -> compila os tres documentos
#      ./build.sh Monografia -> compila apenas um documento
set -e
cd "$(dirname "$0")"
mkdir -p Entregas

saida_de() {
  case "$1" in
    Monografia)        echo "Monografia_Completa.pdf" ;;
    RevisaoLiteratura) echo "Atividade2_Revisao_de_Literatura.pdf" ;;
    Introducao)        echo "Atividade3_Introducao.pdf" ;;
    *)                 echo "$1.pdf" ;;
  esac
}

if [ $# -gt 0 ]; then DOCS="$*"; else DOCS="Monografia RevisaoLiteratura Introducao"; fi

for doc in $DOCS; do
  echo "==> $doc"
  if ! latexmk -pdf -interaction=nonstopmode -halt-on-error "$doc.tex" > /dev/null 2>&1; then
    echo "    ERRO ao compilar $doc — veja $doc.log"
    grep -n '^!' -A3 "$doc.log" | head -20
    exit 1
  fi
  destino="Entregas/$(saida_de "$doc")"
  cp "$doc.pdf" "$destino"
  echo "    $destino ($(pdfinfo "$doc.pdf" | awk '/Pages/{print $2}') paginas)"
done
