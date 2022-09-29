import mqtt from "mqtt";

const host = "hairdresser.cloudmqtt.com";
const port = "25656";
const clientId = `mqtt_${Math.random().toString(16).slice(3)}`;

const connectUrl = `mqtts://${host}:${port}`;

const client = mqtt.connect(connectUrl, {
  clientId,
  clean: true,
  connectTimeout: 4000,
  username: "iscqccyj",
  password: "WNadSQVdUR8C",
  reconnectPeriod: 1000,
});

const topic = "environ/office-grow";
client.on("connect", () => {
  console.log("Connected");
  client.subscribe([topic], () => {
    console.log(`Subscribe to topic '${topic}'`);
  });
});

client.on("message", (topic, payload) => {
  console.log("Received Message:", topic, payload.toString());
  const message = JSON.parse(payload.toString());
  return message.msg;
});

// client.on("connect", () => {
//   client.publish(
//     topic,
//     "nodejs mqtt test",
//     { qos: 0, retain: false },
//     (error) => {
//       if (error) {
//         console.error(error);
//       }
//     }
//   );
// });
