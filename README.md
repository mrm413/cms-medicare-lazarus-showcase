# Lazarus: CMS Medicare Payment System — COBOL-to-Hardened C++17

**55 production CMS Medicare pricer programs | 92,535 lines of COBOL → 97,924 lines of hardened C++17 | 55/55 compile (100%) | Zero external dependencies**

This repository contains the **output** of the Lazarus transpilation system applied to real-world CMS (Centers for Medicare & Medicaid Services) payment system COBOL. Every `.cpp` file here was generated automatically from production Medicare pricer source code. Lazarus is a proprietary transpilation engine built by [Torsova LLC](https://lazarus-systems.com).

---

## What This Is — And What It Isn't

CMS Medicare pricers are the COBOL programs that calculate payment rates for Medicare services across the United States. These are not toy programs — they are production mainframe code with packed decimals, REDEFINES overlays, OCCURS DEPENDING ON tables, COMP-3 arithmetic, and multi-level copybook hierarchies.

This repository proves two specific things:

1. **All 55 production programs transpile cleanly** through the Lazarus C++17 pipeline.
2. **All 55 generated C++17 programs compile clean** under `g++ -std=c++17 -Wall -Wextra -Wpedantic`.

What this repository does **not** claim, and is careful not to imply:
- It does **not** claim runtime byte-for-byte parity for the C++17 outputs. Runtime parity for these specific programs has been independently verified on the **Ironclad / Rust** sister pipeline (see [Cross-Validation](#cross-validation-via-ironcladrust) below); the C++17 outputs in this repo are validated at compile-time only at this milestone.
- It does **not** claim performance equivalence to the mainframe reference.
- It does **not** claim any AI/LLM was used in transpilation. The pipeline is fully deterministic.

---

## At a Glance

| Metric | Value |
|--------|-------|
| COBOL programs processed | 55 |
| C++17 programs generated | 55 (100%) |
| C++17 programs that compile clean | 55 (100%) |
| Total COBOL lines | 92,535 |
| Total hardened C++17 lines | 97,924 |
| External dependencies | 0 |
| C++ standard | C++17 (`-std=c++17 -Wall -Wextra -Wpedantic`) |
| AI/LLM in the loop | None |

### Pricer Systems

| System | Programs | Description |
|--------|---------:|-------------|
| ESRD (End-Stage Renal Disease) | 21 | Dialysis facility payment rates |
| LTCH (Long-Term Care Hospital) | 30 | Long-term acute care DRG pricing |
| Hospice | 2 | Hospice per-diem payment rates |
| SNF (Skilled Nursing Facility) | 2 | PDPM nursing facility payment rates |
| **Total** | **55** | |

---

## Why This Matters

These are the actual COBOL programs that run on CMS mainframes to determine how much Medicare pays hospitals, dialysis centers, hospice providers, and skilled nursing facilities. The COBOL has characteristics that break most transpilers:

- **REDEFINES chains** — fields redefining fields that redefine other fields (up to 3 levels deep)
- **COMP-3 packed decimal** — mainframe BCD arithmetic (`PIC S9(11)V99 COMP-3`)
- **80-column fixed format** — sequence numbers in cols 1-6, indicator in col 7, code in cols 8-72
- **Deep copybook hierarchies** — 69 copybooks with cross-program shared data structures
- **Table lookups** — OCCURS with DEPENDING ON, binary search, multi-dimensional indexing
- **Mixed numeric types** — COMP, COMP-3, DISPLAY numeric, with implicit conversion between all of them
- **CALL/LINKAGE SECTION** — multi-program subroutine architecture (driver/calculator pattern)

Lazarus handles all of this deterministically — same COBOL input always produces the same C++17 output.

---

## The Six-Stage Pipeline

```
  COBOL Source (.cob)
      |
      v
  [1. Dialect Normalizer ]    IBM Enterprise COBOL -> GnuCOBOL-compatible
      |                        Chained REDEFINES resolved to originals
      v
  [2. Preprocessor ]          COPY/REPLACE expanded inline
      |                        Copybook paths resolved
      v
  [3. GnuCOBOL C Backend ]   COBOL -> C intermediate (cobc -C)
      |
      v
  [4. C-to-C++ Transform ]   C patterns -> idiomatic C++17
      |                        goto -> structured control flow
      v
  [5. Hardener ]              Bounds checking, RAII, const correctness
      |
      v
  [6. Compiler ]              g++ -std=c++17 -Wall -Wextra -Werror -O2
      v
  Native Executable
```

Every stage is deterministic. No randomness, no LLM, no heuristics.

---

## Repository Structure

```
cms-medicare-lazarus-showcase/
  README.md                # This file
  cobol_source/            # All 55 original COBOL programs
  cpp_output/              # All 55 hardened C++17 programs
  samples/                 # 4 curated before/after pairs
    snfdr211/              # SNF Driver — wage index + CBSA lookups
    escal212/              # ESRD Calculation — dialysis rate math
    esdrv212/              # ESRD Driver — file I/O + CALL linkage
    hospr210/              # Hospice Pricer — per-diem payment rates
```

---

## How to Verify the 55/55 Compile Claim

```bash
# Compile every output file with strict warnings
cd cpp_output
for cat in */; do
    for prog in "$cat"*.cpp; do
        g++ -std=c++17 -Wall -Wextra -Wpedantic -O2 -c "$prog" -o /dev/null 2>&1 \
            && echo "OK: $prog" \
            || echo "FAIL: $prog"
    done
done | tee compile_log.txt
grep -c "^OK:"  compile_log.txt   # should be 55
grep -c "^FAIL:" compile_log.txt  # should be 0
```

---

## Cross-Validation via Ironclad/Rust

The same 55 CMS Medicare programs are also transpiled by the [Ironclad COBOL→Rust pipeline](https://github.com/mrm413/cms-medicare-ironclad-showcase) — a sister project that runs a parallel byte-for-byte parity harness against the original mainframe outputs.

Through that harness, byte-for-byte runtime parity has been independently verified for the following CMS Medicare program families:

- **SNF** (Skilled Nursing Facility) — FY2021 series, 3 programs
- **ESRD** (End-Stage Renal Disease) — ESDRV200/212 + 20× ESCAL fiscal years 2007–2021
- **Hospice** — FY2021
- **Home Health** — FY2020 + FY2021
- **IPF** (Inpatient Psychiatric Facility) — FY2022
- **IRF** (Inpatient Rehabilitation Facility) — IRCAL201 batch
- **LTCH** + SNFPR190 — Ironclad-track validated

This cross-validation confirms that the source COBOL in this repository is real, executable, and produces verifiable mainframe outputs — independent of which target language the Lazarus suite is transpiling to.

The Lazarus C++17 outputs in *this* repository are validated at the compile gate; runtime parity for the C++17 track is on the roadmap and will be reported in a follow-up release with the same level of evidence (per-test JSON output, runner script, etc.) as the [Lazarus federal-suite repo](https://github.com/mrm413/lazarus-cobol-showcase).

---

## Type Mapping

| COBOL | C++17 | Notes |
|-------|-------|-------|
| `PIC X(N)` | `FixedString<N>` | Space-padded, bounds-checked, overflow-safe |
| `PIC 9(N)` | `int32_t` / `int64_t` | Display numeric |
| `PIC S9(N)` | `int32_t` / `int64_t` | Signed display |
| `PIC S9(N)V9(M)` | `CobolDecimal` | Fixed-point exact arithmetic |
| `PIC S9(N) COMP` | `int16_t` / `int32_t` / `int64_t` | Binary native |
| `PIC S9(N) COMP-3` | `PackedDecimal` | BCD packed decimal |
| `88-level` | `enum class` | Condition names |
| `OCCURS N TIMES` | `std::array<T, N>` | Bounds-checked fixed array |
| `OCCURS DEPENDING ON` | `std::vector<T>` | Variable length |
| `REDEFINES` | `std::variant` / overlay | Type-safe reinterpretation |
| `FD file-name` | `CobolFile` | RAII file descriptor |

---

## Security Hardening

Every generated C++17 file includes the following hardening measures:

- **Type Safety** — COBOL-compatible fixed types (`FixedString<N>`, `CobolDecimal`)
- **Bounds Checking** — All array access validated at compile time and runtime
- **Memory Safety** — RAII, smart pointers only, no raw `new`/`delete`
- **Input Validation** — All inputs sanitized before use
- **Exception Safety** — Comprehensive error handling with strong guarantees
- **Const Correctness** — Immutable where possible
- **Buffer Overflow Protection** — `FixedString<N>` truncates on assignment, never overflows
- **No `unsafe` patterns** — No raw pointer arithmetic, no unchecked casts

---

## Sample Output

### COBOL Input (SNFDR211 — SNF Driver, excerpt)

```cobol
000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID.          SNFDR211.
000300*AUTHOR.                 CMS.
000800*REMARKS. (CENTERS FOR MEDICARE AND MEDICAID SERVICES)
000900***         - NATIONAL SNF PRICER EFFECTIVE OCT 1, 2020
001000***         - SNF PRICER REFERS TO A PROGRAM WHICH WILL
001100***           CALCULATE THE MEDICARE RATE UPON WHICH THE
001200***           PDPM SNF PPS PAYMENT IS MADE.
```

### C++17 Output (excerpt)

```cpp
template<std::size_t N>
class FixedString {
private:
    std::array<char, N> data_;

public:
    FixedString() noexcept { data_.fill(' '); }

    // Safe assignment with automatic truncation
    FixedString& operator=(const char* s) noexcept {
        data_.fill(' ');
        if (s) {
            const std::size_t len = std::min(std::strlen(s), N);
            std::copy_n(s, len, data_.begin());
        }
        return *this;
    }
};
```

Every COBOL data structure becomes a C++17 class with bounds checking. Every `PIC` clause maps to the correct C++ type. Every paragraph becomes a function. The compiler enforces safety on every line.

---

## Sister Pipelines

Lazarus is one of three COBOL transpilers in the same suite:

- **[Lazarus — COBOL → C++17](https://github.com/mrm413/lazarus-cobol-showcase)** — federal-suite track: 1,192/1,192 runtime parity (100%), 1,607/1,607 compile (100%)
- **[Ironclad — COBOL → Rust](https://github.com/mrm413/cms-medicare-ironclad-showcase)** — same 55 CMS Medicare programs, byte-for-byte parity verified (see [Cross-Validation](#cross-validation-via-ironclad-rust))
- **Bobo — COBOL → Java** — parity validation in progress

---

## Related Showcases

- [CMS Medicare — Ironclad Rust](https://github.com/mrm413/cms-medicare-ironclad-showcase) — same 55 programs, Rust target
- [Lazarus federal-suite C++17](https://github.com/mrm413/lazarus-cobol-showcase) — 1,607 GnuCOBOL test programs, 1,192/1,192 runtime parity
- [Lazarus CardDemo](https://github.com/mrm413/lazarus-carddemo-showcase) — AWS CardDemo CICS/COBOL system, 44 programs + CICS runtime + 3270 web UI

---

## Built By

**Torsova LLC** — [lazarus-systems.com](https://lazarus-systems.com)

Lazarus is part of a suite of legacy modernization tools including transpilers for COBOL (C++17 and Rust), VB6, Stored Procedures, Crystal Reports, SAS, and Microsoft Access.

---

## License

Licensed under the [Apache License, Version 2.0](LICENSE).

The original CMS Medicare pricer programs are U.S. Government works in the public domain.

All modifications and additions — including the C++17 transpiled programs, security hardening, build system, and test suite — are Copyright 2025–2026 Michael R. Mull / Lazarus Systems. See [NOTICE](NOTICE) for details.
