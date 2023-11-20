const express = require("express");
const os = require("os");

const app = express();
const port = 3000;

app.get("/sleep", async (req, res) => {
  let sum = 0;
  for (let i = 0; i < 1e8; i++) {
    sum += i;
  }
  res.send("Sleep done");
});

app.listen(port, () => {
  console.log(`Sleep API listening at http://localhost:${port}`);
});
