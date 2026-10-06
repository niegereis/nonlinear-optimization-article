#!/usr/bin/env bash
# Observa os arquivos .tex do TCC e, a cada alteracao salva, regenera os PDFs em Entregas/.
# Uso: ./watch.sh          (deixe rodando em um terminal; Ctrl+C para parar)
cd "$(dirname "$0")"
LOG="watch.log"
assinatura() { find . -name '*.tex' -not -path './Entregas/*' -exec stat -f '%m %N' {} \; | sort | md5; }
echo "[$(date '+%H:%M:%S')] observando arquivos .tex — Ctrl+C para parar" | tee -a "$LOG"
ANTERIOR=$(assinatura)
while true; do
  sleep 2
  ATUAL=$(assinatura)
  if [ "$ATUAL" != "$ANTERIOR" ]; then
    ANTERIOR=$ATUAL
    sleep 1   # espera o editor terminar de salvar
    ANTERIOR=$(assinatura)
    echo "[$(date '+%H:%M:%S')] alteracao detectada — recompilando..." | tee -a "$LOG"
    if ./build.sh >> "$LOG" 2>&1; then
      echo "[$(date '+%H:%M:%S')] OK — PDFs atualizados em Entregas/" | tee -a "$LOG"
    else
      echo "[$(date '+%H:%M:%S')] ERRO de compilacao — veja $LOG" | tee -a "$LOG"
    fi
  fi
done
