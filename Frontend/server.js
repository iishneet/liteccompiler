const express = require("express");
const fs = require("fs");
const path = require("path");
const { exec } = require("child_process");
const { v4: uuidv4 } = require("uuid");

const app = express();
const PORT = 3000;

app.use(express.json());
app.use(express.static("public"));

app.post("/run", (req, res) => {
  const code = req.body.code;
  const id = uuidv4().slice(0, 6);
  const cFile = path.join(__dirname, `temp_${id}.c`);
  const outFile = path.join(__dirname, `temp_${id}.out`);

  fs.writeFileSync(cFile, code);

  exec(`gcc ${cFile} -o ${outFile}`, (compileErr, _, compileStderr) => {
    if (compileErr) {
      cleanUp();
      return res.send(`❌ Compilation Error:\n${compileStderr}`);
    }

    exec(`${outFile}`, { timeout: 3000 }, (runErr, stdout, runStderr) => {
      cleanUp();
      if (runErr) {
        return res.send(`⚠️ Runtime Error:\n${runStderr || runErr.message}`);
      }
      return res.send(stdout);
    });
  });

  function cleanUp() {
    try {
      fs.unlinkSync(cFile);
      fs.unlinkSync(outFile);
    } catch (e) {}
  }
});

app.listen(PORT, () => {
  console.log(`✅ Server running at http://localhost:${PORT}`);
});
