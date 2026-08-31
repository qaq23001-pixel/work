const { spawn } = require('child_process');
const fs = require('fs');
const path = require('path');

const PORT = "8080";
const pwd = __dirname;
const filePath = path.join(pwd, '.npm');

if (!fs.existsSync(filePath)) {
    fs.mkdirSync(filePath, { recursive: true });
}

// 【新】固定 UUID，不会因为重启而改变
const generated_uuid = "92f1c0a3-b7d4-4a2e-9c8d-5f6e7a8b9c0d";
console.log(`当前固定 UUID: ${generated_uuid}`);

const templateFile = 'config.template.json';
const configFile = 'config.json';

// 读取模板，替换 UUID，生成最终配置
if (fs.existsSync(templateFile)) {
    let content = fs.readFileSync(templateFile, 'utf8');
    content = content.replace('YOUR_UUID_PLACEHOLDER', generated_uuid);
    fs.writeFileSync(configFile, content);
    console.log("已根据固定UUID生成最终的config.json");
} else {
    console.log("错误：找不到 config.template.json，请检查文件名！");
}

console.log(`启动 VLESS+WS 监听内部端口: ${PORT}`);

function startSingBox() {
    const child = spawn('sing-box', ['run', '-c', 'config.json'], { stdio: 'inherit' });
    child.on('exit', (code) => {
        console.log(`sing-box 退出代码: ${code}，5秒后自动重启...`);
        setTimeout(startSingBox, 5000);
    });
    child.on('error', (err) => {
        console.error("无法启动 sing-box: ", err.message);
        if (err.code === 'ENOENT') {
            console.error("致命错误：找不到 sing-box 二进制文件！请检查 Dockerfile 架构或镜像路径。");
            process.exit(1);
        }
        setTimeout(startSingBox, 5000);
    });
}

startSingBox();
