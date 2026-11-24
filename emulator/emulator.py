import time
import json
import random
import paho.mqtt.client as mqtt

BROKER = "mosquitto"
PORT = 1883

client = mqtt.Client("Device_Emulator")
client.connect(BROKER, PORT, 60)

print("Starting MQTT & Zigbee Device Emulator...")

while True:
    mqtt_temp = round(random.uniform(18.0, 26.0), 1)
    mqtt_hum = round(random.uniform(40.0, 70.0), 1)
    mqtt_power = round(random.uniform(50.0, 350.0), 2)

    client.publish("tele/mqtt_temp_sensor/state", json.dumps({"temperature": mqtt_temp}), qos=1)
    client.publish("tele/mqtt_hum_sensor/state", json.dumps({"humidity": mqtt_hum}), qos=1)
    client.publish("tele/mqtt_power_meter/state", json.dumps({"power": mqtt_power}), qos=1)

    zb_temp = round(random.uniform(19.0, 23.0), 1)
    zb_door = random.choice(["CLOSED", "OPEN"])
    
    client.publish("zigbee2mqtt/zb_temp_sensor", json.dumps({"temperature": zb_temp, "battery": 95}), qos=1)
    client.publish("zigbee2mqtt/zb_door_sensor", json.dumps({"contact": zb_door, "battery": 88}), qos=1)

    print(f"[MQTT] Temp: {mqtt_temp}°C | [Zigbee] Temp: {zb_temp}°C, Door: {zb_door}")
    time.sleep(5)
