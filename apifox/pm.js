// 异步调用 node 执行本地 loadEnv.js 脚本
const result = await pm.executeAsync(
  "loadEnv.js", // 无具体文件，填空
  [], // 参数,无
  {
    command: "node", // 用 node 解释器执行 .js 文件
    cwd: "d:/github/meme2046/docker/apifox", // 脚本所在目录
  },
);

// 处理执行结果，注入 Apifox 环境变量
try {
  const envVars = JSON.parse(result);
  Object.entries(envVars).forEach(([key, val]) => {
    pm.environment.set(key, val);
    console.log(`✔已注入环境变量：${key} = ${val}`);
  });
} catch (err) {
  console.error(err);
}
