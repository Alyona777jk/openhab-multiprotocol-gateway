#!/bin/bash
echo "=== Starting Multi-Protocol IoT Device Simulator ==="

# 1. Публікуємо статус онлайн та топологію Zigbee Mesh
docker exec iot-mosquitto mosquitto_pub -t "sensors/room1/status" -m "ONLINE" -r
docker exec iot-mosquitto mosquitto_pub -t "zigbee2mqtt/bridge/networkmap" -m "Coordinator(0x0000) <-> Router_Bulb(0x4A12, LQI:145) <-> EndDevice_Door(0x8F01, LQI:92)" -r

# 2. Ініціалізація Zigbee пристроїв
docker exec iot-mosquitto mosquitto_pub -t "zigbee2mqtt/zb_bulb_01" -m '{"state":"OFF","brightness":0,"linkquality":145}' -r
docker exec iot-mosquitto mosquitto_pub -t "zigbee2mqtt/zb_door_01" -m '{"contact":true,"battery":98,"linkquality":92}' -r
docker exec iot-mosquitto mosquitto_pub -t "zigbee2mqtt/zb_trv_01" -m '{"occupied_heating_setpoint":20.0,"system_mode":"auto"}' -r

echo "[1/3] Initial states published. Simulating cold room (17.5°C)..."
sleep 3
docker exec iot-mosquitto mosquitto_pub -t "sensors/room1/climate" -m '{"temp": 17.5, "hum": 54}'
docker exec iot-mosquitto mosquitto_pub -t "actuators/plug1/power" -m '{"watts": 1500.5}'

echo "[2/3] Simulating Zigbee Front Door OPEN event..."
sleep 4
docker exec iot-mosquitto mosquitto_pub -t "zigbee2mqtt/zb_door_01" -m '{"contact":false,"battery":98,"linkquality":94}'

echo "[3/3] Simulating room warmed up (23.0°C)..."
sleep 4
docker exec iot-mosquitto mosquitto_pub -t "sensors/room1/climate" -m '{"temp": 23.0, "hum": 48}'
docker exec iot-mosquitto mosquitto_pub -t "actuators/plug1/power" -m '{"watts": 0.0}'

echo "=== Simulation cycle complete ==="
