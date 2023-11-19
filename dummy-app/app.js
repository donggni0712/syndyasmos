const express = require("express");
const os = require("os");
const client = require("prom-client");

const register = new client.Registry();
client.collectDefaultMetrics({ register });

// 사용자 정의 메트릭을 Registry에 등록
const cpuUsage = new client.Gauge({
  name: "system_cpu_usage",
  help: "System CPU usage percentage",
});
register.registerMetric(cpuUsage);

const memoryUsage = new client.Gauge({
  name: "system_memory_usage",
  help: "System memory usage percentage",
});
register.registerMetric(memoryUsage);

// 나머지 코드는 동일...

let lastCPUTimes = os.cpus().map((cpu) => cpu.times);

// CPU 사용률 계산
function calculateCPUUsage() {
  const cpus = os.cpus();
  let totalIdle = 0,
    totalTick = 0;
  let idleDiff, totalDiff;

  cpus.forEach((cpu, i) => {
    idleDiff = cpu.times.idle - lastCPUTimes[i].idle;
    totalDiff =
      Object.values(cpu.times).reduce((acc, cur) => acc + cur) -
      Object.values(lastCPUTimes[i]).reduce((acc, cur) => acc + cur);

    totalIdle += idleDiff;
    totalTick += totalDiff;
  });

  lastCPUTimes = cpus.map((cpu) => cpu.times);

  return (1 - totalIdle / totalTick) * 100;
}

// 메트릭 업데이트 함수
function updateMetrics() {
  const totalMemory = os.totalmem();
  const freeMemory = os.freemem();
  const usedMemory = totalMemory - freeMemory;
  const memoryUsagePercent = (usedMemory / totalMemory) * 100;

  memoryUsage.set(memoryUsagePercent);
  cpuUsage.set(calculateCPUUsage());
}

// 주기적인 메트릭 업데이트
setInterval(updateMetrics, 5000);

const app = express();
const port = 3000;

// /metrics 엔드포인트에서 메트릭 노출
app.get("/metrics", async (req, res) => {
  res.set("Content-Type", register.contentType);
  res.end(await register.metrics());
});

app.get("/sleep", async (req, res) => {
  let sum = 0;
  for (let i = 0; i < 1e8; i++) {
    sum += i;
  }
  // 지연 후 응답
  res.send("Sleep done");
});

app.listen(port, () => {
  console.log(`Sleep API listening at http://localhost:${port}`);
});
