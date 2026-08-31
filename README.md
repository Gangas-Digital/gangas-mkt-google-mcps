# Gangas MKT Google MCPs

Instalador e catálogo de MCPs para Google Ads, GA4, Google Tag Manager e Search Console.

O repositório não contém credenciais nem tokens. Cada utilizador autentica as suas próprias contas Google e escolhe os serviços que pretende ativar.

## Instalação rápida

```bash
git clone https://github.com/gangas-digital/gangas-mkt-google-mcps.git
cd gangas-mkt-google-mcps
./install.sh --source-root /caminho/para/Documents/Codex/mcps/Google
```

Para instalar apenas uma conta:

```bash
./install.sh --source-root /caminho/para/Documents/Codex/mcps/Google \
  --account armenioganga@gangas.pt --services google_ads,ga4
```

O instalador gera uma lista de verificação em `~/.config/gangas-mkt-google-mcps/installation.json` e um template de configuração para o cliente do agente.

## Princípios

- Uma conta Google por perfil, sem misturar tokens.
- Modo de leitura por omissão.
- Nunca fazer commit de credenciais, refresh tokens ou dados pessoais.
- Validar uma leitura real depois da autenticação.
- Alterações de orçamento e operações de escrita exigem implementação e confirmação explícitas.

## Próximas fases

1. Integrar os repositórios MCP do GitHub como submódulos ou pacotes versionados.
2. Acrescentar health checks e autenticação comum.
3. Gerar configurações para Cursor, Windsurf e outros clientes.
4. Adicionar Looker Studio, BigQuery e Merchant Center.
