from pathlib import Path

RESULT_FILE = Path("lunar_result.txt")
HISTORY_FILE = Path("lunar_state_history.txt")
data = {}

for line in RESULT_FILE.read_text().splitlines():
    if "=" in line:
        key, value = line.split("=", 1)
        data[key.strip()] = value.strip()

traction = float(data["TRACTION_SCORE"])
power = float(data["POWER_MARGIN"])
slope = float(data["TERRAIN_SLOPE"])
temperature = int(data["MOTOR_TEMP"])
signal = int(data["SIGNAL"])
speed = float(data["SPEED"])
state = data["ANALYSIS_STATE"]
previous_state = None

if HISTORY_FILE.exists():
    previous_state = HISTORY_FILE.read_text().strip()
if previous_state == "UNDER_STRESS" and state == "CALM":
    awareness_state = "RECOVERING"
    recommendation = "CONTINUE CAUTIOUSLY AND MONITOR RECOVERY"
elif state == "UNDER_STRESS":
    awareness_state = "UNDER_STRESS"
    recommendation = "HALT AND ASSESS LUNAR CONDITIONS"
elif state == "DEGRADED":
    awareness_state = "DEGRADED"
    recommendation = "REDUCE SPEED AND MONITOR TERRAIN"
else:
    awareness_state = "CALM"
    recommendation = "CONTINUE LUNAR TRAVERSE"

print()
print("======================================")
print("   GILDRA LUNAR SURFACE AWARENESS")
print("======================================")
print("ROVER:           GILDRA-LR01")
print(f"TRACTION:        {traction:.1f}%")
print(f"POWER MARGIN:    {power:.1f}%")
print(f"TERRAIN SLOPE:   {slope:.1f} deg")
print(f"MOTOR TEMP:      {temperature} C")
print(f"SIGNAL:          {signal}%")
print(f"SPEED:           {speed:.2f} m/s")
print("--------------------------------------")
if previous_state:
    print(f"PREVIOUS STATE:  {previous_state}")

print(f"ENGINEERING:     {state}")
print(f"AWARENESS STATE: {awareness_state}")
print(f"RECOMMENDATION:  {recommendation}")
print("======================================")

HISTORY_FILE.write_text(state)
