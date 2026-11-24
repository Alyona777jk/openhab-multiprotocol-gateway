# Multi-Protocol IoT Gateway (OpenHAB 4 + MQTT + Zigbee)

Уніфікований IoT-шлюз на базі **OpenHAB 4**, який забезпечує інтероперабельність між пристроями протоколів **MQTT** та **Zigbee**, нормалізує моделі даних та надає єдиний **REST API** і веб-інтерфейс управління.

## Архітектура системи
openhab/
├── conf/
│ ├── items/
│ ├── rules/
│ ├── sitemaps/
│ └── things/
└── addons/
└── bindings/
1. MQTT Integration
MQTT broker підключення (Mosquitto емуляція)
Мінімум 3 віртуальних MQTT sensors
Subscribe/Publish operations
QoS handling
2. Zigbee Coordination
Zigbee coordinator емуляція
Мінімум 3 Zigbee devices емуляція
Mesh network simulation
Device pairing workflow
3. Protocol Bridge
Автоматична синхронізація стану між протоколами
Unified data model
Cross-protocol automation rules

Error handling та reconnection logic
4. REST API
Єдиний endpoint для всіх пристроїв
Device discovery endpoint
Status monitoring API
Control commands API

