#!/data/data/com.termux/files/usr/bin/bash

set -e

SCENARIO="${1:-normal}"

echo "======================================"
echo "   GILDRA LUNAR MISSION START"
echo "======================================"
echo "SCENARIO: $SCENARIO"
echo

case "$SCENARIO" in

    normal)
        SOURCE="lunar_telemetry.cob"
        BINARY="lunar_telemetry"
        ;;

    degraded)
        SOURCE="lunar_telemetry_degraded.cob"
        BINARY="lunar_telemetry_degraded"
        ;;

    stress)
        SOURCE="lunar_telemetry_stress.cob"
        BINARY="lunar_telemetry_stress"
        ;;
    recovery)
        SOURCE="lunar_telemetry_recovery.cob"
        BINARY="lunar_telemetry_recovery"
        ;;
    *)
        echo "Unknown scenario: $SCENARIO"
        echo
        echo "Usage:"
        echo "  ./run_lunar.sh normal"
        echo "  ./run_lunar.sh degraded"
        echo "  ./run_lunar.sh stress"
        echo "  ./run_lunar.sh recovery"        
exit 1
        ;;
esac

echo "[1/3] Generating COBOL lunar telemetry..."
cobc -x -o "$BINARY" "$SOURCE"
./"$BINARY"

echo
echo "[2/3] Running FORTRAN engineering analysis..."
lfortran lunar_analyzer.f90 -o lunar_analyzer
./lunar_analyzer

echo
echo "[3/3] Running Gildra awareness..."
python lunar_awareness.py

echo
echo "LUNAR MISSION CYCLE COMPLETE"
