# Lazarus: CMS Medicare Payment System — COBOL-to-Hardened C++17 Transpilation

**55 CMS Medicare pricer programs | 92,535 lines of production COBOL | 97,924 lines of hardened C++17 | 100% compile | Zero external dependencies**

This repository contains the **output** of the Lazarus transpilation system applied to real-world CMS (Centers for Medicare & Medicaid Services) payment system COBOL. Every `.cpp` file here was generated automatically from production Medicare pricer source code.

Lazarus is a proprietary transpilation engine built by [Torsova LLC](https://lazarus-systems.com). The source code for Lazarus is not included in this repository.

---

## What Is This?

CMS Medicare pricers are the COBOL programs that calculate payment rates for Medicare services across the United States. These are not toy programs — they are production mainframe code with packed decimals, REDEFINES overlays, OCCURS DEPENDING ON tables, COMP-3 arithmetic, and multi-level copybook hierarchies.

Lazarus transpiled all 55 programs to security-hardened C++17. This repository is the proof.

| Metric | Value |
|--------|-------|
| COBOL programs processed | 55 |
| C++17 programs generated | 55 (100%) |
| C++17 programs that compile | 55 (100%) |
| Total COBOL lines | 92,535 |
| Total hardened C++17 lines | 97,924 |
| External dependencies | 0 |
| C++ standard | C++17 (`-std=c++17 -Wall -Wextra -Wpedantic`) |
| AI/LLM in the loop | None |

### Pricer Systems

| System | Programs | Description |
|--------|----------|-------------|
| ESRD (End-Stage Renal Disease) | 21 | Dialysis facility payment rates |
| LTCH (Long-Term Care Hospital) | 30 | Long-term acute care DRG pricing |
| Hospice | 2 | Hospice per-diem payment rates |
| SNF (Skilled Nursing Facility) | 2 | PDPM nursing facility payment rates |

---

## Why This Matters

These are not test programs. They are the actual COBOL that runs on CMS mainframes to determine how much Medicare pays hospitals, dialysis centers, hospice providers, and skilled nursing facilities.

The COBOL has characteristics that break most transpilers:

- **REDEFINES chains** — fields redefining fields that redefine other fields (up to 3 levels deep)
- **COMP-3 packed decimal** — mainframe BCD arithmetic (`PIC S9(11)V99 COMP-3`)
- **80-column fixed format** — sequence numbers in cols 1-6, indicator in col 7, code in cols 8-72
- **Deep copybook hierarchies** — 69 copybooks with cross-program shared data structures
- **Table lookups** — OCCURS with DEPENDING ON, binary search, multi-dimensional indexing
- **Mixed numeric types** — COMP, COMP-3, DISPLAY numeric, with implicit conversion between all of them
- **CALL/LINKAGE SECTION** — multi-program subroutine architecture (driver/calculator pattern)

Lazarus handles all of this deterministically.

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
  [5. Hardener ]              Security hardening pass
      |                        Bounds checking, RAII, const correctness
      v
  [6. Compiler ]              g++ -std=c++17 -Wall -Wextra -Werror -O2
      v
  Native Executable            55 production binaries
```

Every stage is deterministic. Same COBOL input always produces the same C++17 output. No randomness, no LLM, no heuristics.

---

## Repository Structure

```
cms-medicare-lazarus-showcase/
  README.md                          # This file
  cobol_source/                      # All 55 original COBOL programs
  cpp_output/                        # All 55 hardened C++17 programs
  samples/                           # 4 curated before/after pairs
    snfdr211/                        # SNF Driver — wage index + CBSA lookups
    escal212/                        # ESRD Calculation — dialysis rate math
    esdrv212/                        # ESRD Driver — file I/O + CALL linkage
    hospr210/                        # Hospice Pricer — per-diem payment rates
```

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

## Looking at the Output

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

### C++17 Output (SNFDR211, excerpt)

```cpp
/**
 * LAZARUS-Generated Hardened C++ Code
 *
 * SECURITY STATUS: HARDENED
 * COMPLIANCE: Production-Ready
 *
 * Build with: g++ -std=c++17 -Wall -Wextra -Werror -O2
 */

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

## Compile Results

All 55 programs compile with `g++ -std=c++17 -Wall -Wextra -Wpedantic`. The generated C++17 passes strict compiler warnings, producing 55 native executables from 92,535 lines of mainframe COBOL.

| System | Programs | Compile |
|--------|----------|---------|
| ESRD (Dialysis) | 21 | 21/21 |
| LTCH (Long-Term Care) | 30 | 30/30 |
| Hospice | 2 | 2/2 |
| SNF (Skilled Nursing) | 2 | 2/2 |

---

## What Makes This Different

1. **Real production code** — Not test programs. These are the actual CMS Medicare pricers that determine payment rates for millions of Medicare claims.
2. **Enterprise COBOL complexity** — REDEFINES chains, COMP-3 packed decimals, 69 copybooks, multi-program CALL linkage. The hard stuff that toy transpilers skip.
3. **Security hardened** — Every output file includes bounds checking, RAII memory management, const correctness, and buffer overflow protection.
4. **Deterministic** — Same COBOL input always produces the same C++17 output. No randomness, no LLM, no heuristic guessing.
5. **Zero dependencies** — Pure C++17 standard library only. No external libraries, no FFI, no legacy C bindings.
6. **Government-grade** — Audit trail, reproducible builds, NIST-friendly provenance chain.

---

## Also Available: Ironclad (Rust)

All 55 CMS Medicare programs also compile through the [Ironclad](https://github.com/mrm413/cms-medicare-ironclad-showcase) pipeline to Rust with 100% compile success. Lazarus (C++17) and Ironclad (Rust) are complementary — same COBOL input, different target languages, different tradeoffs.

---

## Also Available: GnuCOBOL Test Suite

Lazarus also achieves [100% pass rate on the full GnuCOBOL 3.2 validation suite](https://github.com/mrm413/lazarus-cobol-showcase) — 1,607/1,607 test programs transpiled and compiled to hardened C++17.

---

## Related Showcases

- [CMS Medicare — Ironclad Rust](https://github.com/mrm413/cms-medicare-ironclad-showcase) -- 55 CMS Medicare pricer programs transpiled to Rust (100%)
- [Lazarus COBOL Showcase](https://github.com/mrm413/lazarus-cobol-showcase) -- 1,607 GnuCOBOL test programs transpiled to hardened C++17 (100%)
- [Lazarus CardDemo Showcase](https://github.com/mrm413/lazarus-carddemo-showcase) -- 44 AWS CardDemo CICS/COBOL programs transpiled to C++17 (100%)

---

## Related Showcases

- [CMS Medicare — Ironclad Rust](https://github.com/mrm413/cms-medicare-ironclad-showcase) -- 55 CMS Medicare pricer programs transpiled to Rust (100%)
- [GnuCOBOL Test Suite — Lazarus C++17](https://github.com/mrm413/lazarus-cobol-showcase) -- 1,607 GnuCOBOL 3.2 test programs transpiled to hardened C++17 (100%)
- [Lazarus CardDemo Showcase](https://github.com/mrm413/lazarus-carddemo-showcase) -- 44 AWS CardDemo CICS/COBOL programs transpiled to C++17 (100%)

---

## Built By

**Torsova LLC** — [lazarus-systems.com](https://lazarus-systems.com)

Lazarus is part of a suite of legacy modernization tools including transpilers for COBOL (C++17 and Rust), VB6, Stored Procedures, Crystal Reports, SAS, and Microsoft Access.

---

## License

Licensed under the [Apache License, Version 2.0](LICENSE).

The original CMS Medicare pricer programs are U.S. Government works in the public domain.

All modifications and additions -- including the C++17 transpiled programs, security hardening, build system, and test suite -- are Copyright 2025 Michael R. Mull / Lazarus Systems. See [NOTICE](NOTICE) for details.
