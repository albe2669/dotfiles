#!/usr/bin/env python3
"""
Extract zen-browser profile settings and generate nix configuration snippets.

Usage:
  python3 extract-zen-settings.py              # auto-detect profile
  python3 extract-zen-settings.py /path/to/profile
  python3 extract-zen-settings.py --json       # output raw JSON only
"""

import json
import os
import re
import struct
import sys
from pathlib import Path

# ---------------------------------------------------------------------------
# Profile detection
# ---------------------------------------------------------------------------

SYSTEM_EXTENSION_IDS = {
    "webcompat@mozilla.org",
    "data-leak-blocker@mozilla.com",
    "formautofill@mozilla.org",
    "ipp-activator@mozilla.com",
    "newtab@mozilla.org",
    "pictureinpicture@mozilla.org",
    "addons-search-detection@mozilla.com",
    "default-theme@mozilla.org",
}

# Known extension ID → nixpkgs firefox-addons name
KNOWN_EXTENSIONS = {
    "uBlock0@raymondhill.net": "ublock-origin",
    "{d7742d87-e61d-4b78-b8a1-b469842139fa}": "vimium",
    "addon@darkreader.org": "darkreader",
    "{d634138d-c276-4fc8-924b-40a0ea21d284}": "1password",  # check nixpkgs
    "jetpack-extension@dashlane.com": "dashlane",            # may not be in nixpkgs
    "{a4c4eda4-fb84-4a84-b4a1-f7c1cbf2a1ad}": "refined-github",
    "uMatrix@raymondhill.net": "umatrix",
    "firefoxdav@icloud.com": None,  # not in nixpkgs
    "jid1-MnnxcxisBPnSXQ@jetpack": "privacy-badger",
    "VirtualMachineNativeMessagingHost@btk.ff.ext": None,
}


def find_zen_profile() -> Path | None:
    candidates = [
        # macOS
        Path.home() / "Library" / "Application Support" / "zen" / "Profiles",
        # Linux (common locations)
        Path.home() / ".zen",
        Path.home() / ".mozilla" / "zen",
        Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local" / "share")) / "zen",
    ]
    for base in candidates:
        if not base.exists():
            continue
        # Prefer "Default (release)" profile
        for p in sorted(base.iterdir()):
            if p.is_dir() and "Default" in p.name and not p.name.startswith("."):
                return p
        # Fallback: any non-hidden directory
        for p in sorted(base.iterdir()):
            if p.is_dir() and not p.name.startswith("."):
                return p
    return None


# ---------------------------------------------------------------------------
# prefs.js parsing
# ---------------------------------------------------------------------------

# Patterns for keys that represent ephemeral state, not declarative config
SKIP_RE = re.compile(
    r"""
    lastUpdateTime | lastColdStartup | lastBuildId | last_check |
    laterrun | sessionCount | profileCreationTime |
    buildID | buildId | \.mstone | appVersion | platformVersion |
    migrationsApplied | migration\.version | \.migrat |
    normandy | datareporting | glean | cachedClient | cachedProfile |
    captchadetection | sessionCheckpoints | sessionstore |
    devtools\.toolbox | devtools\.netmonitor\.panes |
    devtools\.toolsidebar | devtools\.debugger\.pending |
    devtools\.everOpened |
    devtools\.performance\.recording |
    \.last-build-id | zen\.updates\. | zen\.session-store |
    zen\.ui\.migration | zen\.keyboard\.shortcuts\.version |
    zen\.live-folders\.promotion | zen\.mods\.last-update |
    zen\.mods\.milestone | zen\.workspaces\.active |
    zen\.urlbar\.suggestions-learner |
    has-used | \.shown$ | alreadyShown | firstRun |
    impressionId | userAgentID | user_id | \.userID |
    cachedUsage | colorway-builtin-themes-cleanup |
    databaseSchema | signatureCheckpoint |
    startup\.couldRestore | lastAppBuildId | lastAppVersion |
    lastPlatformVersion | pendingOperations |
    ipProtection\.locationListCache |
    pageActions\.persistedActions | pagethumbnails\.storage_version |
    safebrowsing.*lastupdatetime | safebrowsing.*nextupdatetime |
    serpEventTelemetry |
    urlbar\.lastUrlbar | urlbar\.suggestions-learner |
    urlbar\.quicksuggest\.migrationVersion |
    region\.update | rights\.\d+\.shown |
    upgrade.*BuildID | homepage_override |
    shell\.mostRecentDate | termsofuse | proton\.toolbar |
    shield-preference | targeting\.snapshot |
    weave\. | broadcast |
    distribution\. | doh-rollout\. | app\.update\. | app\.normandy\. |
    browser\.bookmarks\.addedImport | browser\.bookmarks\.restore_default |
    browser\.download\.lastDir | browser\.engagement\. |
    browser\.laterrun\. | browser\.migration\. |
    browser\.newtabpage\.activity-stream\.impressionId |
    browser\.newtabpage\.storageVersion |
    browser\.policies\.applied | browser\.search\.region |
    browser\.startup\.couldRestore | browser\.startup\.last |
    browser\.search\.totalSearches |
    extensions\.active | extensions\.blocklist |
    extensions\.colorway | extensions\.database |
    extensions\.last | extensions\.pending |
    extensions\.signature | extensions\.system |
    extensions\.dnr\.last |
    network\.cookie\.CHIPS\.last |
    privacy\.bounceTracking.*Migrat |
    privacy\.purge_trackers |
    privacy\.sanitize.*Migrat | privacy\.sanitize\.pending |
    privacy\.trackingprotection\.allow_list\.has |
    services\.settings\. | services\.sync\. |
    toolkit\.profiles\.storeID | toolkit\.startup\.last |
    toolkit\.telemetry |
    dom\.push\.userAgent |
    browser\.search\.serpEvent |
    browser\.safebrowsing |
    browser\.startup\.homepage_override |
    browser\.region |
    browser\.uiCustomization\.state |
    browser\.urlbar\.placeholderName |
    browser\.download\.viewableInternally |
    media\.gmp |
    nimbus\. |
    idle\.last |
    gecko\.handlerService |
    places\.database\.last |
    storage\.vacuum\. |
    sidebar\.backupState |
    devtools\.debugger\.prefs-schema |
    devtools\.netmonitor\.columns |
    devtools\.netmonitor\.panes |
    devtools\.netmonitor\.msg |
    devtools\.toolsidebar
    """,
    re.VERBOSE | re.IGNORECASE,
)


def parse_prefs(profile: Path) -> dict:
    prefs_file = profile / "prefs.js"
    if not prefs_file.exists():
        return {}

    pattern = re.compile(r'user_pref\("([^"]+)",\s*(.*)\);')
    prefs = {}
    for line in prefs_file.read_text(encoding="utf-8").splitlines():
        m = pattern.match(line.strip())
        if not m:
            continue
        key, raw_val = m.group(1), m.group(2).strip()
        # Parse value
        if raw_val == "true":
            val = True
        elif raw_val == "false":
            val = False
        elif raw_val.startswith('"') and raw_val.endswith('"'):
            val = raw_val[1:-1]
        else:
            try:
                val = int(raw_val)
            except ValueError:
                try:
                    val = float(raw_val)
                except ValueError:
                    val = raw_val
        prefs[key] = val
    return prefs


def filter_prefs(prefs: dict) -> dict:
    return {k: v for k, v in prefs.items() if not SKIP_RE.search(k)}


# ---------------------------------------------------------------------------
# mozlz4 decoder (pure Python, no external deps)
# ---------------------------------------------------------------------------

def _lz4_block_decompress(src: bytes, uncompressed_size: int) -> bytes:
    """Decompress an LZ4 block (no frame header)."""
    dst = bytearray(uncompressed_size)
    sp = 0
    dp = 0
    end = len(src)

    while sp < end:
        token = src[sp]; sp += 1

        # Literal length
        llen = token >> 4
        if llen == 15:
            while True:
                x = src[sp]; sp += 1
                llen += x
                if x < 255:
                    break

        # Copy literals
        dst[dp:dp + llen] = src[sp:sp + llen]
        dp += llen
        sp += llen

        if sp >= end:
            break  # last sequence has no match

        # Match offset (little-endian 16-bit)
        offset = src[sp] | (src[sp + 1] << 8); sp += 2

        # Match length (min 4)
        mlen = (token & 0xF) + 4
        if (token & 0xF) == 15:
            while True:
                x = src[sp]; sp += 1
                mlen += x
                if x < 255:
                    break

        # Copy match (may overlap, so byte-by-byte)
        mp = dp - offset
        for i in range(mlen):
            dst[dp] = dst[mp + i]
            dp += 1

    return bytes(dst[:dp])


def decode_mozlz4(path: Path) -> dict | list | None:
    """Decode a Mozilla mozlz4 file into a Python object."""
    try:
        data = path.read_bytes()
    except OSError:
        return None
    if data[:8] != b'mozLz40\x00':
        return None
    uncompressed_size = struct.unpack_from('<I', data, 8)[0]
    try:
        decompressed = _lz4_block_decompress(data[12:], uncompressed_size)
        return json.loads(decompressed)
    except Exception:
        return None


# ---------------------------------------------------------------------------
# JSON file helpers
# ---------------------------------------------------------------------------

def read_json(profile: Path, filename: str) -> dict | list | None:
    f = profile / filename
    if not f.exists():
        return None
    try:
        return json.loads(f.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return None


# ---------------------------------------------------------------------------
# Session / tab extraction
# ---------------------------------------------------------------------------

def _tab_url(tab: dict) -> str:
    initial = (tab.get('_zenPinnedInitialState') or {}).get('entry') or {}
    if initial.get('url'):
        return initial['url']
    entries = tab.get('entries') or []
    return entries[-1].get('url', '') if entries else ''


def _tab_title(tab: dict) -> str:
    initial = (tab.get('_zenPinnedInitialState') or {}).get('entry') or {}
    if initial.get('title'):
        return initial['title']
    entries = tab.get('entries') or []
    return entries[-1].get('title', '') if entries else ''


def extract_session_data(profile: Path) -> dict:
    """
    Returns a dict with:
      spaces:        {uuid -> name}
      essential_tabs: list of tab dicts (zenEssential=True)
      pinned_tabs:    list of tab dicts (pinned, not essential)
      live_folders:   list of live-folder dicts (from zen-live-folders.jsonlz4)
      folders:        list of folder group dicts (from session windows[0].folders)
    """
    result = {
        "spaces": {},
        "essential_tabs": [],
        "pinned_tabs": [],
        "live_folders": [],
        "folders": [],
    }

    # Decode session
    session_file = profile / "sessionstore-backups" / "recovery.jsonlz4"
    if not session_file.exists():
        session_file = profile / "sessionstore-backups" / "previous.jsonlz4"
    session = decode_mozlz4(session_file) if session_file.exists() else None

    if session:
        windows = session.get('windows') or []
        win = windows[0] if windows else {}

        # Build spaces map
        for sp in win.get('spaces') or []:
            uid = sp.get('uuid', '')
            name = sp.get('name') or sp.get('icon') or uid
            result['spaces'][uid] = name

        # Extract tabs
        for tab in win.get('tabs') or []:
            if not tab.get('pinned'):
                continue
            url = _tab_url(tab)
            title = _tab_title(tab)
            entry = {
                'url': url,
                'title': title,
                'workspace': tab.get('zenWorkspace', ''),
                'container': tab.get('userContextId', 0),
                'essential': bool(tab.get('zenEssential')),
                'live_folder_id': tab.get('zenLiveFolderItemId'),
            }
            if entry['essential']:
                result['essential_tabs'].append(entry)
            else:
                result['pinned_tabs'].append(entry)

        # Folder groups
        result['folders'] = win.get('folders') or []

    # Live folders
    lf_data = decode_mozlz4(profile / "zen-live-folders.jsonlz4")
    if isinstance(lf_data, list):
        result['live_folders'] = lf_data

    return result


# ---------------------------------------------------------------------------
# Nix formatting helpers
# ---------------------------------------------------------------------------

def nix_value(v) -> str:
    if isinstance(v, bool):
        return "true" if v else "false"
    if isinstance(v, int):
        return str(v)
    if isinstance(v, float):
        return str(v)
    # String — escape for nix
    escaped = str(v).replace("\\", "\\\\").replace('"', '\\"').replace("${", "\\${")
    return f'"{escaped}"'


def nix_pref_key(k: str) -> str:
    # Keys with dots must be quoted in nix
    return f'"{k}"'


def prefs_to_nix(prefs: dict, indent: int = 8) -> str:
    pad = " " * indent
    lines = []
    for k, v in sorted(prefs.items()):
        lines.append(f"{pad}{nix_pref_key(k)} = {nix_value(v)};")
    return "\n".join(lines)


L10N_NAMES = {
    "user-context-personal": "Personal",
    "user-context-work": "Work",
    "user-context-banking": "Banking",
    "user-context-shopping": "Shopping",
    "user-context-vacation": "Vacation",
    "user-context-no-container": "No Container",
}


def containers_to_nix(containers_json: dict, indent: int = 6) -> str:
    pad = " " * indent
    inner_pad = pad + "  "
    lines = []
    for identity in containers_json.get("identities", []):
        if not identity.get("public", False) or identity.get("isPrivate", False):
            continue
        l10n = identity.get("l10nId", "")
        name = identity.get("name") or L10N_NAMES.get(l10n, l10n or "Unknown")
        color = identity.get("color", "blue")
        icon = identity.get("icon", "fingerprint")
        cid = identity.get("userContextId", 0)
        nix_name = f'"{name}"' if not name.replace("_", "").replace("-", "").isalnum() else name
        lines.append(f"{pad}{nix_name} = {{")
        lines.append(f"{inner_pad}color = \"{color}\";")
        lines.append(f"{inner_pad}icon = \"{icon}\";")
        lines.append(f"{inner_pad}id = {cid};")
        lines.append(f"{pad}}};")
    return "\n".join(lines)


def shortcuts_to_nix(shortcuts_json: dict, indent: int = 8) -> str:
    pad = " " * indent
    inner_pad = pad + "  "
    lines = []
    for s in shortcuts_json.get("shortcuts", []):
        if s.get("internal", False):
            continue  # skip built-in defaults
        sid = s.get("id", "?")
        key = s.get("key", "")
        keycode = s.get("keycode", "")
        mods = s.get("modifiers", {})
        disabled = s.get("disabled", False)
        mod_parts = [m for m in ["control", "alt", "shift", "meta", "accel"] if mods.get(m)]
        mod_str = "+".join(mod_parts)
        binding = f"{mod_str}+{key or keycode}" if mod_str else (key or keycode or "?")
        lines.append(f"{pad}# {sid}: {binding}{' [DISABLED]' if disabled else ''}")
    return "\n".join(lines) if lines else f"{pad}# (no custom shortcuts found)"


# ---------------------------------------------------------------------------
# Extension extraction
# ---------------------------------------------------------------------------

def extract_extensions(profile: Path) -> list[dict]:
    data = read_json(profile, "extensions.json")
    if not data:
        return []
    results = []
    for addon in data.get("addons", []):
        if not addon.get("active", False):
            continue
        if addon.get("type") not in ("extension", None):
            # skip themes, etc (they still have type "extension" in FF)
            pass
        eid = addon.get("id", "")
        if eid in SYSTEM_EXTENSION_IDS:
            continue
        name = addon.get("defaultLocale", {}).get("name") or addon.get("name", eid)
        version = addon.get("version", "?")
        nix_name = KNOWN_EXTENSIONS.get(eid)
        results.append({
            "id": eid,
            "name": name,
            "version": version,
            "nix_name": nix_name,
        })
    return results


# ---------------------------------------------------------------------------
# Main report
# ---------------------------------------------------------------------------

def print_section(title: str) -> None:
    print()
    print(f"{'=' * 70}")
    print(f"  {title}")
    print(f"{'=' * 70}")


def run(profile: Path, json_output: bool = False) -> None:
    prefs_raw = parse_prefs(profile)
    prefs = filter_prefs(prefs_raw)

    containers_json = read_json(profile, "containers.json") or {}
    shortcuts_json = read_json(profile, "zen-keyboard-shortcuts.json") or {}
    extensions = extract_extensions(profile)
    session = extract_session_data(profile)

    # Split prefs into categories
    zen_prefs = {k: v for k, v in prefs.items() if k.startswith("zen.")}
    browser_prefs = {k: v for k, v in prefs.items() if k.startswith("browser.")}
    privacy_prefs = {k: v for k, v in prefs.items() if k.startswith("privacy.")}
    network_prefs = {k: v for k, v in prefs.items() if k.startswith("network.")}
    toolkit_prefs = {k: v for k, v in prefs.items() if k.startswith("toolkit.")}
    other_prefs = {
        k: v for k, v in prefs.items()
        if not any(k.startswith(p) for p in ["zen.", "browser.", "privacy.", "network.", "toolkit.", "extensions."])
    }

    if json_output:
        print(json.dumps({
            "profile": str(profile),
            "zen_prefs": zen_prefs,
            "browser_prefs": browser_prefs,
            "privacy_prefs": privacy_prefs,
            "network_prefs": network_prefs,
            "toolkit_prefs": toolkit_prefs,
            "other_prefs": other_prefs,
            "containers": containers_json.get("identities", []),
            "extensions": extensions,
            "custom_shortcuts": [
                s for s in shortcuts_json.get("shortcuts", []) if not s.get("internal", False)
            ],
            "essential_tabs": session["essential_tabs"],
            "pinned_tabs": session["pinned_tabs"],
            "live_folders": session["live_folders"],
        }, indent=2))
        return

    print(f"zen-browser settings extractor")
    print(f"Profile: {profile}")
    print(f"Total prefs (after filtering): {len(prefs)} / {len(prefs_raw)} raw")

    # ---- EXTENSIONS ----
    print_section("Extensions (user-installed)")
    print()
    print("  extensions.packages = with inputs.firefox-addons.packages.\"${system}\"; [")
    for ext in extensions:
        nix = ext["nix_name"]
        if nix:
            print(f"    {nix}  # {ext['name']} {ext['version']}")
        else:
            print(f"    # MISSING IN NIXPKGS: {ext['name']} ({ext['id']}) {ext['version']}")
    print("  ];")

    # ---- CONTAINERS ----
    print_section("Containers")
    print()
    print("  containers = {")
    print(containers_to_nix(containers_json))
    print("  };")

    # ---- ZEN PREFS ----
    print_section("Zen-specific preferences (zen.*)")
    print()
    print("  settings = {")
    print(prefs_to_nix(zen_prefs))
    print("  };")

    # ---- BROWSER PREFS ----
    print_section("Browser preferences (browser.*)")
    print()
    print("  settings = {")
    print(prefs_to_nix(browser_prefs))
    print("  };")

    # ---- PRIVACY PREFS ----
    print_section("Privacy preferences (privacy.*)")
    print()
    print("  settings = {")
    print(prefs_to_nix(privacy_prefs))
    print("  };")

    # ---- NETWORK PREFS ----
    if network_prefs:
        print_section("Network preferences (network.*)")
        print()
        print("  settings = {")
        print(prefs_to_nix(network_prefs))
        print("  };")

    # ---- TOOLKIT PREFS ----
    if toolkit_prefs:
        print_section("Toolkit preferences (toolkit.*)")
        print()
        print("  settings = {")
        print(prefs_to_nix(toolkit_prefs))
        print("  };")

    # ---- OTHER PREFS ----
    if other_prefs:
        print_section("Other preferences")
        print()
        print("  settings = {")
        print(prefs_to_nix(other_prefs))
        print("  };")

    # ---- ESSENTIAL TABS ----
    spaces = session["spaces"]

    def ws_name(uid: str) -> str:
        return spaces.get(uid, uid or "default")

    print_section("Essential tabs (zenEssential)")
    print()
    if session["essential_tabs"]:
        print("  # NOTE: Not yet declaratively configurable in the nix module.")
        print("  # These tabs are restored from the session store.")
        print()
        # Group by workspace
        by_ws: dict[str, list] = {}
        for t in session["essential_tabs"]:
            ws = ws_name(t["workspace"])
            by_ws.setdefault(ws, []).append(t)
        for ws, tabs in by_ws.items():
            print(f"  # Workspace: {ws}")
            for t in tabs:
                container = f"  [container={t['container']}]" if t['container'] else ""
                title = t['title'][:55] if t['title'] else t['url']
                print(f"  #   {title}{container}")
                print(f"  #   -> {t['url']}")
    else:
        print("  # No essential tabs found.")

    # ---- PINNED TABS (non-essential) ----
    print_section("Pinned tabs (non-essential)")
    print()
    if session["pinned_tabs"]:
        print("  # NOTE: Not yet declaratively configurable in the nix module.")
        print()
        by_ws = {}
        for t in session["pinned_tabs"]:
            ws = ws_name(t["workspace"])
            by_ws.setdefault(ws, []).append(t)
        for ws, tabs in by_ws.items():
            print(f"  # Workspace: {ws}")
            for t in tabs:
                container = f"  [container={t['container']}]" if t['container'] else ""
                lf = f"  [live-folder={t['live_folder_id']}]" if t['live_folder_id'] else ""
                title = t['title'][:55] if t['title'] else t['url']
                print(f"  #   {title}{container}{lf}")
                print(f"  #   -> {t['url']}")
    else:
        print("  # No non-essential pinned tabs found.")

    # ---- LIVE FOLDERS (GITHUB FOLDERS) ----
    print_section("Live folders (GitHub folders)")
    print()
    folders_by_id = {f['id']: f for f in session.get('folders', [])}
    if session["live_folders"]:
        for lf in session["live_folders"]:
            fid = lf.get('id', '?')
            ftype = lf.get('type', '?')
            folder_meta = folders_by_id.get(fid, {})
            name = folder_meta.get('name') or fid
            ws_uid = folder_meta.get('workspaceId', '')
            ws = ws_name(ws_uid)
            state = (lf.get('data') or {}).get('state') or {}
            url = state.get('url', '?')
            lf_type = state.get('type', '?')
            interval_min = state.get('interval', 0) // 60000
            options = state.get('options') or {}
            repos = state.get('repos') or []

            print(f"  # [{ftype}] {name}  (workspace: {ws})")
            print(f"  #   URL:      {url}")
            print(f"  #   Type:     {lf_type}")
            print(f"  #   Interval: {interval_min} min")
            if options.get('authorMe'):
                print(f"  #   Filter:   authored by me")
            if options.get('reviewRequested'):
                print(f"  #   Filter:   review requested")
            if repos:
                print(f"  #   Repos:    {', '.join(repos[:5])}" +
                      (f" (+{len(repos)-5} more)" if len(repos) > 5 else ""))
            excludes = options.get('repoExcludes') or []
            if excludes:
                print(f"  #   Excludes: {', '.join(excludes[:3])}" +
                      (f" (+{len(excludes)-3} more)" if len(excludes) > 3 else ""))
            print()
    else:
        print("  # No live folders found.")

    # ---- KEYBOARD SHORTCUTS ----
    print_section("Custom keyboard shortcuts")
    print()
    custom = [s for s in shortcuts_json.get("shortcuts", []) if not s.get("internal", False)]
    if custom:
        print("  # zen-keyboard-shortcuts.json: non-internal shortcuts")
        print("  # (paste raw JSON into zen.keyboard.shortcuts if the nix module supports it)")
        print()
        for s in custom:
            mods = s.get("modifiers", {})
            mod_parts = [m for m in ["control", "alt", "shift", "meta", "accel"] if mods.get(m)]
            binding = "+".join(mod_parts + [s.get("key") or s.get("keycode") or "?"])
            disabled = " [DISABLED]" if s.get("disabled") else ""
            print(f"  # {s['id']}: {binding}{disabled}")
    else:
        print("  # No custom shortcuts found.")

    # ---- COMBINED NIX SNIPPET ----
    print_section("Combined nix snippet (copy into profiles.\"default\".settings)")
    print()
    all_settings = {**zen_prefs, **browser_prefs, **privacy_prefs, **network_prefs, **toolkit_prefs, **other_prefs}
    print("  settings = {")
    print(prefs_to_nix(all_settings))
    print("  };")


def main() -> None:
    args = sys.argv[1:]
    json_output = "--json" in args
    args = [a for a in args if not a.startswith("--")]

    if args:
        profile = Path(args[0])
        if not profile.exists():
            print(f"Error: profile directory not found: {profile}", file=sys.stderr)
            sys.exit(1)
    else:
        profile = find_zen_profile()
        if not profile:
            print("Error: could not auto-detect zen profile directory.", file=sys.stderr)
            print("Try: python3 extract-zen-settings.py /path/to/zen/profile", file=sys.stderr)
            sys.exit(1)

    run(profile, json_output)


if __name__ == "__main__":
    main()
