# Multi-Protocol IoT Gateway (OpenHAB 4 + MQTT + Zigbee)

Уніфікований IoT-шлюз на базі **OpenHAB 4**, який забезпечує інтероперабельність між пристроями протоколів **MQTT** та **Zigbee**, нормалізує моделі даних та надає єдиний **REST API** і веб-інтерфейс управління.

## Архітектура системи

```mermaid
graph LR
    subgraph MQTT_Domain [MQTT Protocol Domain]
        M1[Climate Sensor<br/>JSON Payload]
        M2[Hallway PIR<br/>Raw String]
        M3[Smart Plug<br/>Command/State]
    end

    subgraph Zigbee_Domain [Zigbee Mesh Domain]
        Z1[Zigbee Bulb<br/>Router LQI:145]
        Z2[Door Contact<br/>EndDevice LQI:92]
        Z3[Radiator TRV<br/>EndDevice]
        ZC((Zigbee Coordinator))
        Z1 --- ZC
        Z2 --- Z1
        Z3 --- ZC
    end

    subgraph OpenHAB_Gateway [OpenHAB 4 Multi-Protocol Gateway]
        Broker[Mosquitto MQTT Broker]
        Trans[JSONPATH & Format<br/>Transformations]
        Items[Unified Data Model<br/>Items & Groups]
        Rules[Cross-Protocol<br/>Rules Engine]
        REST[OpenHAB REST API<br/>/rest/items]
        UI[Basic UI Sitemap]
    end

    M1 & M2 & M3 <-->|TCP/IP QoS 1| Broker
    ZC <-->|Zigbee Bridge Topics| Broker
    Broker <--> Trans
    Trans <--> Items
    Items <--> Rules
    Items <--> REST
    Items <--> UI
Механізм протокольної трансформаціїВхідна трансформація (Inbound): Сирі JSON-повідомлення з MQTT ({"temp": 17.5, "hum": 54}) та Zigbee ({"contact": false, "linkquality": 92}) парсяться за допомогою JSONPATH Transformation Service у типізовані одиниці вимірювання OpenHAB (Number:Temperature, Contact, Dimmer).Вихідна трансформація (Outbound): Команди з єдиного API або правил (ON, 23.0) форматуються через formatBeforePublish у специфічні JSON-команди Zigbee ({"occupied_heating_setpoint":23.0}) або топіки MQTT.Запуск через Git BashЗапустити контейнери:Bashdocker-compose up -d
Відкрити OpenHAB UI (http://localhost:8080), створити обліковий запис адміністратора та встановити аддони через Settings -> Bindings / Transformations:MQTT BindingJSONPath TransformationRRD4j PersistenceЗапустити симулятор пристроїв для демонстрації cross-protocol правил:Bashbash zigbee-emulator/simulator.sh
Документація REST APIБазовий URL: http://localhost:8080/rest (для POST/PUT запитів у OpenHAB 4 потрібен API Token або увімкнений Allow Basic Authentication у Settings -> API Security).ПризначенняМетодEndpointПриклад запиту / відповідіDevice Discovery (Всі пристрої)GET/rest/items/gAllDevicesПовертає JSON-масив усіх інтегрованих MQTT та Zigbee пристроївФільтрація за протоколомGET/rest/items/gZigbeeDevicesПовертає лише Zigbee-вузли та їхні метрики (LQI, Battery)Моніторинг стануGET/rest/items/MQTT_RoomTemp/stateПовертає поточне значення, напр. 17.5 °CУправління (Control API)POST/rest/items/ZB_BulbSwitchBody (text/plain): ON або OFFЗапуск Zigbee PairingPOST/rest/items/ZB_PermitJoinBody (text/plain): ON (відкриває мережу на 60 сек)EOF
