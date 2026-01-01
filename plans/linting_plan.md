If you’re doing agentic iOS dev from the CLI, linting isn’t “a tool you run,” it’s a control system: deterministic inputs → deterministic outputs → no human bikeshedding → fast feedback loops.

Here’s the setup that tends to be optimal in practice.

1) Split responsibilities: formatter ≠ linter

Formatting: pick one authority and make it automatic.
	•	Apple’s swift-format is now a first-class citizen in the Swift toolchain (Swift 6 / Xcode 16+), and is runnable via swift format or by locating swift-format with xcrun --find swift-format.  ￼
	•	It supports lint mode and can fail on warnings with --strict.  ￼
	•	Config lives in a .swift-format JSON file that’s discovered by walking up directories, and you can dump defaults via swift-format dump-configuration.  ￼

Linting (semantic/style rules): use SwiftLint for the rules formatting won’t (and shouldn’t) own. SwiftLint is heavily SwiftSyntax-based and targets conventions + code smells.  ￼

Why this split matters for agents: formatters are safe(ish) to auto-run; linters are “complain, don’t mutate” unless explicitly asked.

2) Prefer “pinned, repo-local” installs over “everyone brew installs stuff”

Agents thrive on reproducibility. The cleanest pattern now is:
	•	SwiftLint as an SPM plugin (so version is pinned by Package.resolved, works in Xcode and CLI). SwiftLint supports both build tool plugins and a command plugin (swift package plugin swiftlint).  ￼
	•	For Xcode projects, you can add the SwiftLintBuildToolPlugin to the target build phases (“Run Build Tool Plug-ins”).  ￼

This removes the “my SwiftLint version disagrees with CI” class of bugs.

3) Don’t lint broken code (especially not with auto-fix)

SwiftLint explicitly warns that it’s designed to analyze valid, compilable Swift, and non-compiling code can produce confusing results—particularly with --fix / autocorrect.  ￼

In agentic workflows, this is huge: your agent will often have intermediate states that don’t compile. So:
	•	Run formatting early (it’s mostly syntax/whitespace tolerant).
	•	Run SwiftLint when the code compiles (or at least parses cleanly), and treat “compilation gate” as part of the pipeline.

Also: if you integrate SwiftLint via an Xcode Run Script phase, SwiftLint recommends placing it after “Compile Sources.”  ￼

4) Make CI strict; make local fast

Two modes:

Local dev (fast feedback):
	•	Format-on-save in editor if possible, and provide a CLI escape hatch:
	•	swift-format -i -r <dirs> (format recursively, in place)
	•	swift-format lint -s -r <dirs> when you want the “gatekeeper” behavior  ￼
	•	SwiftLint: lint only what changed to keep it snappy (more on that next).

CI (non-negotiable gate):
	•	SwiftLint: swiftlint lint --strict to make warnings fail the build.  ￼
	•	swift-format: swift-format lint --strict … to fail on style warnings.  ￼

This gives you the “agents can move fast locally, but the merge button is a bouncer” model.

5) Incremental linting: only touch changed files

For speed (especially with large iOS monorepos), use “changed-file linting”:
	•	Git-based: lint only git diff’d .swift files (great for agent loops).
	•	Xcode script inputs: SwiftLint supports using Xcode’s script input file environment variables and file lists (SCRIPT_INPUT_FILE_COUNT, SCRIPT_INPUT_FILE_0, etc.), which is the canonical way to avoid linting the universe each build.  ￼

This is one of the biggest practical wins for agentic workflows: your agent runs lint 20 times per hour; you really don’t want full-repo lint 20 times per hour.

6) Output format: humans want “xcode”, agents want JSON/JUnit

SwiftLint has multiple reporter formats (commonly xcode, json, checkstyle, junit, html, etc.).  ￼
Best practice:
	•	Local: reporter: xcode so it reads like native diagnostics.
	•	CI / agents: JSON or JUnit so machines can parse, cluster, and decide what to fix first.

Agent superpower: parse JSON → group by rule → patch systematically → rerun.

7) Legacy codebases: use a baseline instead of a holy war

If you turn on SwiftLint for a big existing app, you’ll get an apocalyptic wall of violations. Baselines let you:
	•	Freeze existing violations (debt ledger),
	•	Enforce “no new violations,”
	•	Pay down gradually.

SwiftLint has baseline-related APIs and there’s active discussion/usage of baseline JSON workflows.  ￼

This is the sane path for “agent refactors” too: your agent can chip away at one rule at a time without exploding PR size.

8) CI + Xcode plugins: avoid interactive trust prompts (carefully)

If you use SwiftLint as an Xcode package/plugin on CI, Xcode can require plugin/macro validation prompts. SwiftLint documents xcodebuild flags like:
	•	-skipPackagePluginValidation
	•	-skipMacroValidation
…and equivalent defaults write … options, with explicit security implications.  ￼

In other words: great for unattended CI, but understand what trust you’re bypassing.

9) The “agentic linting contract” (the meta-best-practice)

Give your agents a single, deterministic contract like:
	1.	Format changed files (mutating)
	2.	Build (must compile)
	3.	Lint changed files (non-mutating, strict in CI)
	4.	Produce machine-readable report (JSON/JUnit)
	5.	Autofix only a whitelisted subset (formatter + a few safe SwiftLint rules), otherwise propose patches

That keeps your agents from becoming chaos gremlins that “fix” style by inventing new style.

⸻

If you want a North Star: make it so a brand-new machine (or agent sandbox) can run one command and get the exact same results as CI, without tribal knowledge. Everything else is just implementation detail and mild suffering.