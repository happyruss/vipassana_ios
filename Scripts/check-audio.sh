#!/bin/sh
# Fails the build when a Bundle audio name from TrackTemplateFactory.swift
# is not a regular file under Vipassana/AudioAssets. Audio files are gitignored;
# this is the launch-crash gate. Run with --self-test to exercise temp fixtures.
set -eu

ROOT="$(CDPATH= cd -- "$(dirname "$0")/.." && pwd)"

compile_checker() {
    xcrun --sdk macosx swiftc -parse-as-library -o "$1" \
        "$ROOT/Vipassana/Managers/AudioManifestCheck.swift" \
        "$ROOT/Scripts/AudioManifestCheckMain.swift"
}

run_checker() {
    if [ -n "${4:-}" ]; then
        "$1" --factory "$2" --audio-dir "$3" --project "$4"
    else
        "$1" --factory "$2" --audio-dir "$3"
    fi
}

if [ "${1:-}" = "--self-test" ]; then
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT
    out="$tmp/audio-manifest-check"
    compile_checker "$out"

    fixture_factory="$tmp/Factory.swift"
    printf '%s\n' 'Bundle.main.path(forResource: "Present", ofType: "m4a")!' > "$fixture_factory"
    fixture_audio="$tmp/audio"
    mkdir -p "$fixture_audio"

    status=0
    run_checker "$out" "$fixture_factory" "$fixture_audio" >"$tmp/missing.out" 2>"$tmp/missing.err" || status=$?
    if [ "$status" -eq 0 ]; then
        echo "error: missing fixture audio should fail the check" >&2
        exit 1
    fi
    grep -q "error: missing bundled audio Present.m4a" "$tmp/missing.err"

    mkdir -p "$fixture_audio/Present.m4a"
    status=0
    run_checker "$out" "$fixture_factory" "$fixture_audio" >"$tmp/dir.out" 2>"$tmp/dir.err" || status=$?
    if [ "$status" -eq 0 ]; then
        echo "error: a directory named like audio should fail the check" >&2
        exit 1
    fi
    rm -rf "$fixture_audio/Present.m4a"
    printf 'x' > "$fixture_audio/Present.m4a"
    run_checker "$out" "$fixture_factory" "$fixture_audio" >"$tmp/present.out" 2>"$tmp/present.err"

    printf '%s\n' 'let unused = 1' > "$tmp/empty.swift"
    status=0
    run_checker "$out" "$tmp/empty.swift" "$fixture_audio" >"$tmp/empty.out" 2>"$tmp/empty.err" || status=$?
    if [ "$status" -eq 0 ]; then
        echo "error: a factory with no audio names should fail closed" >&2
        exit 1
    fi
    grep -q "error: no Bundle audio names found" "$tmp/empty.err"

    empty_audio="$tmp/empty-audio"
    mkdir -p "$empty_audio"
    status=0
    run_checker "$out" "$ROOT/Vipassana/Managers/TrackTemplateFactory.swift" "$empty_audio" >"$tmp/catalog.out" 2>"$tmp/catalog.err" || status=$?
    if [ "$status" -eq 0 ]; then
        echo "error: TrackTemplateFactory audio should fail when the files are absent" >&2
        exit 1
    fi
    sed -n 's/^error: missing bundled audio \(.*\)\.m4a$/\1/p' "$tmp/catalog.err" > "$tmp/actual-names"
    cat > "$tmp/expected-names" <<'EOF'
IntroBell
ClosingBell
Introduction
01_Shamatha
01_Shamatha2
02_Anapana
02_Anapana2
03_FocusedAnapana
03_FocusedAnapana2
04_TopToBottom
04_TopToBottom2
05_TopToBottomBottomToTop
05_TopToBottomBottomToTop2
06_Symmetrical
06_Symmetrical2
07_Sweeping
07_Sweeping2
08_InTheMoment
08_InTheMoment2
MetaPana
EOF
    if ! diff -u "$tmp/expected-names" "$tmp/actual-names"; then
        echo "error: TrackTemplateFactory audio names did not match the manifest check" >&2
        exit 1
    fi

    printf '%s\n' '/* Other.m4a in Resources */,' > "$tmp/not-copied.pbxproj"
    status=0
    run_checker "$out" "$fixture_factory" "$fixture_audio" "$tmp/not-copied.pbxproj" >"$tmp/project.out" 2>"$tmp/project.err" || status=$?
    if [ "$status" -eq 0 ]; then
        echo "error: audio missing from Copy Bundle Resources should fail" >&2
        exit 1
    fi
    grep -q "error: audio not in Copy Bundle Resources Present.m4a" "$tmp/project.err"

    printf '%s\n' '/* Present.m4a in Resources */,' > "$tmp/copied.pbxproj"
    run_checker "$out" "$fixture_factory" "$fixture_audio" "$tmp/copied.pbxproj" >"$tmp/copied.out" 2>"$tmp/copied.err"

    full_audio="$tmp/full-audio"
    mkdir -p "$full_audio"
    while IFS= read -r name; do
        printf 'x' > "$full_audio/${name}.m4a"
    done < "$tmp/expected-names"
    run_checker "$out" "$ROOT/Vipassana/Managers/TrackTemplateFactory.swift" "$full_audio" "$ROOT/Vipassana.xcodeproj/project.pbxproj" >"$tmp/full.out" 2>"$tmp/full.err"
    exit 0
fi

factory="$ROOT/Vipassana/Managers/TrackTemplateFactory.swift"
audio_dir="$ROOT/Vipassana/AudioAssets"
project="$ROOT/Vipassana.xcodeproj/project.pbxproj"
while [ $# -gt 0 ]; do
    case "$1" in
        --factory)
            factory=$2
            shift 2
            ;;
        --audio-dir)
            audio_dir=$2
            shift 2
            ;;
        --project)
            project=$2
            shift 2
            ;;
        *)
            echo "error: unknown argument $1" >&2
            exit 2
            ;;
    esac
done

if [ -n "${TARGET_TEMP_DIR:-}" ]; then
    mkdir -p "$TARGET_TEMP_DIR"
    out="${TARGET_TEMP_DIR}/audio-manifest-check"
    compile_checker "$out"
    run_checker "$out" "$factory" "$audio_dir" "$project"
else
    work="$(mktemp -d)"
    trap 'rm -rf "$work"' EXIT
    out="$work/audio-manifest-check"
    compile_checker "$out"
    run_checker "$out" "$factory" "$audio_dir" "$project"
fi
