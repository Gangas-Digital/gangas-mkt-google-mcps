#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_ROOT=""
ACCOUNT=""
SERVICES="google_ads,ga4,search_console,gtm"
OUT_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/gangas-mkt-google-mcps"

usage() {
  echo "Uso: ./install.sh --source-root PASTA_GOOGLE [--account EMAIL] [--services LISTA] [--out PASTA]"
}
while [[ $# -gt 0 ]]; do
  case "$1" in
    --source-root) SOURCE_ROOT="$2"; shift 2 ;;
    --account) ACCOUNT="$2"; shift 2 ;;
    --services) SERVICES="$2"; shift 2 ;;
    --out) OUT_DIR="$2"; shift 2 ;;
    --help|-h) usage; exit 0 ;;
    *) echo "Opção desconhecida: $1" >&2; exit 2 ;;
  esac
done
[[ -n "$SOURCE_ROOT" ]] || { usage >&2; exit 1; }
[[ -d "$SOURCE_ROOT" ]] || { echo "Pasta não encontrada: $SOURCE_ROOT" >&2; exit 1; }
mkdir -p "$OUT_DIR"

python3 - "$ROOT/manifest/services.json" "$SOURCE_ROOT" "$OUT_DIR" "$ACCOUNT" "$SERVICES" <<'PY'
import json, pathlib, sys
manifest = json.loads(pathlib.Path(sys.argv[1]).read_text())
source = pathlib.Path(sys.argv[2]).expanduser().resolve()
out = pathlib.Path(sys.argv[3]).expanduser().resolve()
account, services = sys.argv[4], sys.argv[5].split(',')
if account and account not in manifest['accounts']:
    raise SystemExit(f'Conta não catalogada: {account}')
entries = []
for key in services:
    if key not in manifest['services']:
        raise SystemExit(f'Serviço não catalogado: {key}')
    meta = manifest['services'][key]
    directory = source / account / meta['directory'] if account else source / meta['directory']
    entries.append({'id': key, 'label': meta['label'], 'source': str(directory), 'exists': directory.exists()})
(out / 'installation.json').write_text(json.dumps({'account': account or None, 'services': entries}, indent=2, ensure_ascii=False) + '\n')
print(f'Configuração criada em {out / "installation.json"}')
for item in entries:
    print(f"- {item['label']}: {'encontrado' if item['exists'] else 'não encontrado'}")
PY

cp "$ROOT/templates/mcp-config.example.json" "$OUT_DIR/mcp-config.json"
echo "Instalação concluída. Revê $OUT_DIR/mcp-config.json antes de ligar o agente."
