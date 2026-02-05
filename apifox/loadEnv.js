const fs = require("fs");
const path = require("path");

// 1. 读取 .env 文件（路径可直接写绝对路径，更稳妥）
const envPath = "d:/.env";
let envContent = "";
try {
  envContent = fs.readFileSync(path.resolve(envPath), "utf8");
  // console.log(`✔ Read『${envPath}』successfully`);
} catch (err) {
  console.error(err);
  process.exit(1); // 读取失败退出脚本
}

// 2. 解析 dotenv 格式
function parseEnv(content) {
  const env = {};
  const lines = content.split(/\r?\n/);
  lines.forEach((line) => {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith("#")) return;
    const eqIndex = trimmed.indexOf("=");
    if (eqIndex === -1) return;
    const key = trimmed.slice(0, eqIndex).trim();
    let value = trimmed.slice(eqIndex + 1).trim();
    if (
      (value.startsWith('"') && value.endsWith('"')) ||
      (value.startsWith("'") && value.endsWith("'"))
    ) {
      value = value.slice(1, -1);
    }
    env[key] = value;
  });
  return env;
}

// 3. 解析并输出结果（转为 JSON 格式，方便 Apifox 接收）
const envVars = parseEnv(envContent);
// console.log("✔解析环境变量成功:\n", envVars);
// 关键：将结果输出到控制台（Apifox 会捕获该输出）
process.stdout.write(JSON.stringify(envVars));
