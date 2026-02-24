# ckgroup-core CLI

Command-line tool for the **CKGroup Adaptive UI Platform**.  
Manages the `page_registry.json` that drives dynamic sidebar pages with role-based access.

---

## Installation

```bash
dart pub global activate --source path packages/ckgroup_core_cli
```

After activation, the `ckgroup-core` executable is available on your `PATH`.

---

## Commands

### `add` — Register a new sidebar page

```
ckgroup-core add --page=<PageName> --roles=<Role1,Role2,...> [options]
```

| Option | Short | Required | Description |
|---|---|---|---|
| `--page` | `-p` | ✅ | Display name shown in the sidebar (e.g. `Loans`) |
| `--roles` | `-r` | ✅ | Comma-separated role names that may access the page |
| `--route` | | | Navigation route path. Defaults to `/<lowercase-page-name>` |
| `--icon` | | | Material icon name for the sidebar entry (e.g. `description`) |
| `--output` | `-o` | | Path to `page_registry.json`. Defaults to `page_registry.json` in the current directory |

#### Examples

```bash
# Basic usage — roles map to any string (case-insensitive at runtime)
ckgroup-core add --page=Loans --roles=Admin,LoanSupervisor,Creditor

# With explicit route and icon
ckgroup-core add --page=Reports --roles=Admin --route=/reports --icon=bar_chart

# Write to a specific asset path inside the Flutter app
ckgroup-core add \
  --page="Credit Review" \
  --roles=Admin,Creditor \
  --output=packages/design_system_showcase/assets/page_registry.json
```

---

## How it works

1. **CLI writes** — `ckgroup-core add` appends a `PageEntry` to `page_registry.json`.  
2. **App reads** — at startup the Flutter app calls `PageRegistryService.loadFromJsonString`  
   with the bundled asset, which registers a `DynamicPageModule` per entry.  
3. **Shell filters** — `ModuleRegistry.forRoleNames(currentUser.roles)` returns only the  
   modules the signed-in user may see; those become `DashboardShell` destinations.

```
┌─────────────────────────────────────────────────────────────┐
│  Developer terminal                                         │
│  $ ckgroup-core add --page=Loans --roles=Admin,Creditor     │
│                           │                                 │
│                  page_registry.json (updated)               │
└───────────────────────────┬─────────────────────────────────┘
                            │  bundled as Flutter asset
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  Flutter app startup                                        │
│  PageRegistryService.loadFromJsonString(json)               │
│     └─ registers DynamicPageModule('/loans')                │
└───────────────────────────┬─────────────────────────────────┘
                            │
                            ▼
┌─────────────────────────────────────────────────────────────┐
│  DashboardShell                                             │
│  ModuleRegistry.forRoleNames(['Creditor'])                  │
│     └─ returns [DynamicPageModule('/loans')]                │
│  Sidebar shows:  📄 Loans                                   │
└─────────────────────────────────────────────────────────────┘
```

---

## Role matching

Roles are **strings** — they are compared case-insensitively at runtime.  
Both built-in `UserRole` enum values and arbitrary custom roles work:

| CLI role string | Matches |
|---|---|
| `Admin` | `UserRole.admin`, or any module with role name `admin` |
| `LoanSupervisor` | Only modules that declare `LoanSupervisor` in their roles |
| `Creditor` | Only modules that declare `Creditor` in their roles |

---

## `page_registry.json` format

```json
{
  "version": "1",
  "pages": [
    {
      "pageName": "Loans",
      "route": "/loans",
      "roles": ["Admin", "LoanSupervisor", "Creditor"],
      "iconName": "loans"
    }
  ]
}
```

---

## Error handling

| Situation | Behaviour |
|---|---|
| Duplicate route | CLI prints an error and exits with code `1` |
| Missing `--page` or `--roles` | `args` library throws a usage error |
| Empty role list after splitting | CLI prints an error and exits with code `1` |
| Invalid JSON in existing file | `FormatException` surfaced to caller |
