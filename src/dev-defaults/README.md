# Dev Defaults (dev-defaults)

Installs a curated set of general-purpose VS Code extensions and editor settings that are independent of any language or framework stack.

No packages are installed at build time — all value is in the `customizations.vscode` block applied when VS Code connects to the container.

## Extensions included

| Extension | Purpose |
|---|---|
| `eamodio.gitlens` | Enhanced Git history and annotations |
| `GitHub.copilot-chat` | GitHub Copilot AI assistant |
| `MS-vsliveshare.vsliveshare` | Live Share collaboration |
| `streetsidesoftware.code-spell-checker` | English spell checking |
| `streetsidesoftware.code-spell-checker-german` | German spell checking |
| `alefragnani.Bookmarks` | Bookmark code locations |
| `Gruntfuggly.todo-tree` | TODO/FIXME tree view |
| `alefragnani.project-manager` | Switch between projects |
| `mutantdino.resourcemonitor` | CPU/memory status bar |
| `usernamehw.errorlens` | Inline error display |
| `christian-kohler.path-intellisense` | Path autocomplete |
| `redhat.vscode-xml` | XML language support |
| `DavidAnson.vscode-markdownlint` | Markdown linting |
| `yzhang.markdown-all-in-one` | Markdown editing and preview |
| `shd101wyy.markdown-preview-enhanced` | Enhanced Markdown preview |
| `janisdd.vscode-edit-csv` | CSV editing |
| `mechatroner.rainbow-csv` | CSV column highlighting |
| `esbenp.prettier-vscode` | Prettier formatter |
| `codeandstuff.package-json-upgrade` | Show available dependency updates |
| `rioj7.command-variable` | Extra variables for tasks and launch configs |

## Settings applied

- `editor.formatOnSave`, `editor.formatOnPaste`
- `editor.rulers: [80]`
- `editor.minimap.renderCharacters: false`
- `workbench.startupEditor: "none"`
- `extensions.ignoreRecommendations: true`
- `github.copilot.nextEditSuggestions.enabled: true`
- `gitlens.hovers.currentLine.over: "line"`
- `git.openRepositoryInParentFolders: "always"`
- `cSpell.language: "en,de-DE"`
- `[markdown]` → formatter: `yzhang.markdown-all-in-one`
- `[json][jsonc]` → formatter: `esbenp.prettier-vscode`

## Example Usage

```jsonc
"features": {
    "ghcr.io/cbs-consulting/container-features/dev-defaults:1": {}
}
```
