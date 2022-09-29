"use strict";
var __create = Object.create;
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __getProtoOf = Object.getPrototypeOf;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toESM = (mod, isNodeMode, target) => (target = mod != null ? __create(__getProtoOf(mod)) : {}, __copyProps(
  isNodeMode || !mod || !mod.__esModule ? __defProp(target, "default", { value: mod, enumerable: true }) : target,
  mod
));
var import_mqtt = __toESM(require("mqtt"));
const host = "hairdresser.cloudmqtt.com";
const port = "25656";
const clientId = `mqtt_${Math.random().toString(16).slice(3)}`;
const connectUrl = `mqtts://${host}:${port}`;
const client = import_mqtt.default.connect(connectUrl, {
  clientId,
  clean: true,
  connectTimeout: 4e3,
  username: "iscqccyj",
  password: "WNadSQVdUR8C",
  reconnectPeriod: 1e3
});
const topic = "environ/office-grow";
client.on("connect", () => {
  console.log("Connected");
  client.subscribe([topic], () => {
    console.log(`Subscribe to topic '${topic}'`);
  });
});
client.on("message", (topic2, payload) => {
  console.log("Received Message:", topic2, payload.toString());
  const message = JSON.parse(payload.toString());
  return message.msg;
});
//# sourceMappingURL=index.js.map
