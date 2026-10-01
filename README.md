# Gildra Lunar Surface Awareness

Gildra Lunar Surface Awareness is a research prototype demonstrating
state-aware interpretation of simulated lunar rover telemetry.

The demonstrator was developed using COBOL, FORTRAN, Python, and Gildra.

It is designed to explore how engineering telemetry can be transformed
into operational awareness while retaining compatibility with
legacy-style software technologies.

## Architecture

Simulated Lunar Rover Telemetry
        |
        v
COBOL Telemetry Generation
        |
        v
FORTRAN Engineering Analysis
        |
        v
Gildra Awareness Layer
        |
        v
Operational Recommendation

### COBOL

COBOL generates simulated telemetry for the GILDRA-LR01 lunar rover.

### FORTRAN

FORTRAN reads the telemetry and performs engineering analysis,
including:

- Traction condition
- Power margin
- Terrain slope
- Motor temperature
- Communications signal
- Rover speed

The analyzer classifies the current engineering condition as:

- CALM
- DEGRADED
- UNDER_STRESS

### Python / Gildra

The Gildra awareness layer interprets the FORTRAN engineering result
and adds temporal context.

Gildra can distinguish between a system that is simply CALM and one
that has transitioned from UNDER_STRESS back into acceptable
engineering conditions.

This allows the awareness layer to identify a RECOVERING state.

## Telemetry

The simulated GILDRA-LR01 rover monitors:

- Battery level
- Motor temperature
- Wheel slip
- Terrain slope
- Communications signal
- Rover speed

## Awareness States

### CALM

Engineering conditions are within the defined demonstration limits.

Recommendation:

CONTINUE LUNAR TRAVERSE

### DEGRADED

One or more engineering conditions have entered a degraded range.

Recommendation:

REDUCE SPEED AND MONITOR TERRAIN

### UNDER_STRESS

One or more engineering conditions have entered the defined
high-stress range.

Recommendation:

HALT AND ASSESS LUNAR CONDITIONS

### RECOVERING

The current engineering analysis has returned to CALM after the
previous cycle was UNDER_STRESS.

Recommendation:

CONTINUE CAUTIOUSLY AND MONITOR RECOVERY

## Demonstration Scenarios

Four simulated scenarios are provided:

- normal
- degraded
- stress
- recovery

Run a normal scenario:

```bash
./run_lunar.sh normal
```

Run a degraded scenario:

```bash
./run_lunar.sh degraded
```

Run a stress scenario:

```bash
./run_lunar.sh stress
```

Run a recovery scenario:

```bash
./run_lunar.sh recovery
```

## State-Aware Recovery Demonstration

To demonstrate temporal awareness, first clear previous state history:

```bash
rm -f lunar_state_history.txt
```

Then run:

```bash
./run_lunar.sh stress
./run_lunar.sh recovery
./run_lunar.sh normal
```

Expected awareness progression:

```text
UNDER_STRESS
     |
     v
RECOVERING
     |
     v
CALM
```

During recovery, the FORTRAN engineering analyzer reports the current
condition as CALM.

Gildra recognizes that the preceding engineering state was
UNDER_STRESS and interprets the transition as RECOVERING.

This separates current-cycle engineering analysis from state-aware
operational interpretation.

## Technology Roles

COBOL:
- Simulated telemetry generation

FORTRAN:
- Engineering calculations
- Current-condition classification

Python / Gildra:
- State history
- Temporal interpretation
- Awareness classification
- Operational recommendation

## Prototype Status

GILDRA-LR01 is a research and technology demonstrator.

All lunar rover telemetry used by this project is simulated.

The project is not NASA flight software, has not been validated for
spaceflight operations, and does not control real spacecraft or rover
hardware.

Its purpose is to demonstrate an architecture for interpreting
engineering telemetry and maintaining operational awareness across
changing system conditions.

## Platform

The prototype was developed and tested on Android using Termux.

Core technologies:

- GnuCOBOL
- FORTRAN / LFortran
- Python
- Bash
- Git
