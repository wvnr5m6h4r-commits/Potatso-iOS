#!/usr/bin/env python3
"""Conservative Swift 2/3 -> 5 mechanical replacements."""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

REPLACEMENTS: list[tuple[str, str]] = [
    ("UIApplication.sharedApplication()", "UIApplication.shared"),
    ("UIScreen.mainScreen()", "UIScreen.main"),
    ("UIColor.whiteColor()", "UIColor.white"),
    ("UIColor.blackColor()", "UIColor.black"),
    ("UIColor.clearColor()", "UIColor.clear"),
    ("UIColor.lightGrayColor()", "UIColor.lightGray"),
    ("UIColor.grayColor()", "UIColor.gray"),
    (".joinWithSeparator(", ".joined(separator:"),
    ("appendContentsOf(", "append(contentsOf: "),
    ("characters.count", "count"),
]

SKIP_DIRS = {"Pods", "Carthage", ".git", "DerivedData"}


def should_skip(path: Path) -> bool:
    parts = set(path.parts)
    return any(d in parts for d in SKIP_DIRS)


def main() -> None:
    for swift in ROOT.rglob("*.swift"):
        if should_skip(swift):
            continue
        text = swift.read_text(encoding="utf-8")
        orig = text
        for a, b in REPLACEMENTS:
            text = text.replace(a, b)
        if text != orig:
            swift.write_text(text, encoding="utf-8")
            print("updated", swift.relative_to(ROOT))


if __name__ == "__main__":
    main()
