---
name: container-features
description: >-
  Sets up the cbs Dev Container Features (ghcr.io/cbs-consulting/container-features) in a
  project: reads the project to pick the Features it needs (CAP, Fiori, Cloud Foundry CLI,
  TypeScript, private npm feeds), writes or extends .devcontainer/devcontainer.json, wires npm
  feed tokens without committing them, and checks the result. Use when the user wants a dev
  container for an SAP BTP, CAP or Fiori project, asks which cbs Feature or option to use, or a
  container build or the npm-feeds token prompt fails.
license: Apache-2.0
---

# cbs Dev Container Features

The Features install the SAP BTP toolchain into a Dev Container. Each one is a few lines in
`devcontainer.json`; the work is choosing the right ones and their options for a project. This
skill covers that choice. The option details live in each Feature's docs, so read them instead of
guessing:

- `https://github.com/cbs-consulting/container-features/blob/main/src/<feature>/README.md`
- `https://raw.githubusercontent.com/cbs-consulting/container-features/main/src/<feature>/devcontainer-feature.json`
  (the `version` field gives the current major tag, the `options` the exact names and defaults)

If this skill was installed as a plugin, the same files are in `../../src/<feature>/` next to it.

## 1. Read the project first

Look before you ask. Collect these signals:

| Signal | Feature and options |
| --- | --- |
| `@sap/cds` in `package.json`, `.cdsrc.json`, `*.cds` files | `cap-dev-stack` |
| `mta.yaml` | `cap-dev-stack` (keep `mbt` and `mta`) and `btp-cli-tools` with `plugins: "multiapps"` for `cf deploy` |
| `manifest.yml`, `xs-security.json`, a `cf` script in `package.json` | `btp-cli-tools` |
| `xs-app.json`, `@sap/html5-app-deployer`, an HTML5 repository module in `mta.yaml` | suggest `html5-plugin` in `btp-cli-tools` `plugins` |
| `ui5.yaml`, `webapp/manifest.json`, `@sap/ux-ui5-tooling`, `@ui5/cli` | `fiori-dev-stack` |
| `tsconfig.json` or `typescript` in `package.json` | `typescript` (major `2`) |
| `@scope:registry=` lines in a project `.npmrc`, or scoped packages from a private registry | `npm-feeds` (see step 3) |
| `engines.node` in `package.json`, `.nvmrc` | the `version` of the Node Feature |
| an existing `.devcontainer/devcontainer.json`, `Dockerfile` or `docker-compose.yml` | extend it, don't replace it |

Two Features have no project signal, so ask instead of adding them silently:

- `dev-defaults` is an opinionated editor setup (Copilot Chat, GitLens, English and German spell
  check, format on save, a ruler at 80). Offer it; some teams have their own.
- `devcontainer-tools` installs the Dev Container CLI. Useful for people who build or test dev
  containers themselves, or run them in CI.

Starting from nothing? The ready-made templates in
[cbs-consulting/container-templates](https://github.com/cbs-consulting/container-templates) may
already fit. Mention them before you write a file by hand.

## 2. Write devcontainer.json

Rules that hold for every Feature:

- **Node first.** Every Feature except `btp-cli-tools` and `dev-defaults` needs npm. Add
  `ghcr.io/devcontainers/features/node` with `"version": "lts"` or the project's major. Without
  it the build stops with `ERROR: npm was not found on PATH`.
- **Debian or Ubuntu base.** `btp-cli-tools` installs from apt. Keep the user's image if it is
  Debian or Ubuntu based; otherwise suggest `mcr.microsoft.com/devcontainers/base:ubuntu`.
- **Major tags.** Reference each Feature by its current major, read from the `version` field
  (today `:1` for all of them and `:2` for `typescript`). `typescript:2` replaced `ts-node` with
  `tsx`; stay on `:1` only if the project needs ts-node.
- **`none` skips a tool.** Every npm-based option takes `latest`, an exact version, or `none`.
  For example `"mbt": "none"` when the project has no `mta.yaml` and the user does not want it.
- **Merge, don't overwrite.** Keep the user's existing keys, comments, Features and
  customizations. Show the diff and say why each Feature is there.

A CAP project with an MTA and a private feed ends up like this:

```jsonc
{
  "name": "my-cap-app",
  "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
  "features": {
    "ghcr.io/devcontainers/features/node:1": { "version": "lts" },
    "ghcr.io/cbs-consulting/container-features/cap-dev-stack:1": {},
    "ghcr.io/cbs-consulting/container-features/btp-cli-tools:1": { "plugins": "multiapps" },
    "ghcr.io/cbs-consulting/container-features/npm-feeds:1": {
      "feeds": "@myorg|https://pkgs.dev.azure.com/org/_packaging/feed/npm/registry/|AZURE_DEVOPS_PAT"
    }
  },
  "remoteEnv": {
    "AZURE_DEVOPS_PAT": "${localEnv:AZURE_DEVOPS_PAT}"
  }
}
```

### Versions: latest or pinned

npm-based tools default to `latest`, resolved when the image is built, so a rebuild can bring a
new `@sap/cds-dk` without any change to the file. Ask once whether the container must be
reproducible (a team, CI, a project in maintenance). If yes, pin exact versions; get the current
one with `npm view <package> version`, for example `"cds-dk": "8.6.1"`. A tag such as `:1.2.0`
also locks the Feature itself.

### Cloud Foundry plugins

`plugins` installs CF Community plugins, which are unreviewed third-party binaries and always
resolve to their latest version. Add only the ones the project needs, and tell the user that
adding them accepts that risk.

## 3. Private npm feeds without leaking tokens

Build the `feeds` string from the project's `.npmrc`:

- One entry per scope: `@scope|registryUrl|TOKEN_VAR`, entries joined with `;`.
- Copy the registry URL as it is, with its trailing slash. Azure DevOps URLs end in
  `/npm/registry/`.
- `TOKEN_VAR` must be a valid variable name (letters, digits, `_`). Feeds sharing one token can
  leave it out and set `token-env-var` instead (default `NPM_TOKEN`).
- Never copy `_authToken`, `_auth` or `_password` lines anywhere. If the project `.npmrc` holds a
  token, tell the user it is committed and should be revoked and removed.

The token reaches the container at post-create time, in this order of preference:

1. **From the host.** `"remoteEnv": { "VAR": "${localEnv:VAR}" }`. The user sets `VAR` on their
   machine (VS Code must be started after it is set). Nothing secret is in the repository.
2. **Codespaces.** A Codespaces secret named `VAR` is set in the container automatically.
3. **The prompt.** If `VAR` is empty, the Feature asks for the token once per variable in the
   terminal of the first start.

Never put a token value in `devcontainer.json`, `containerEnv`, a `Dockerfile` or a committed
`.env` file. The token ends up in `~/.npmrc` with mode `0600` inside the container; that is the
Feature's job, don't do it by hand.

## 4. Check the result

- If the Dev Container CLI is available, run
  `devcontainer read-configuration --workspace-folder .` to validate the file. A full
  `devcontainer build --workspace-folder .` needs Docker and takes minutes; ask before you start
  one.
- Inside the rebuilt container, check what was installed: `node -v`, `cds version`,
  `mbt --version`, `cf version`, `cf plugins`, `tsc -v`, `yo --version`,
  `npm config get @scope:registry`.
- Tell the user to run **Dev Containers: Rebuild and Reopen in Container** in VS Code.

## 5. When something goes wrong

| Symptom | Cause and fix |
| --- | --- |
| `ERROR: npm was not found on PATH` | The Node Feature is missing. Add it. |
| `cf` is missing, the build log says `Cloud Foundry CLI installation failed and will be skipped` | The Cloud Foundry apt repository was unavailable or its key invalid (for example cloudfoundry/cli#3863). The build went on because `skip-cf-on-failure` is `true`. Rebuild later; set it to `false` to make the build fail instead. |
| No token prompt, or the prompt was skipped | Run `bash /usr/local/share/npm-feeds/post-create.sh` in the container terminal. It is safe to run again. |
| `npm install` gets 401 or 403 from the feed | The token is wrong, expired or lacks package read access. Create a new one, then run the post-create script again. |
| `remoteEnv` variable is empty | It was not set on the host when VS Code started. Set it, restart VS Code, rebuild. |
| Tools changed after a rebuild with no config change | `latest` resolved to a newer version. Pin the last working version. |
| `ts-node` is gone | `typescript:2` replaced it with `tsx`. Use `tsx`, or go back to `typescript:1`. |

Report a bug in a Feature at
[cbs-consulting/container-features](https://github.com/cbs-consulting/container-features/issues).
