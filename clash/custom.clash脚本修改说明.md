# 替换规则

1. 读取`template.json`文件中的`ruleSet`加到`config.rules`中
   config.rules = [ruleSet...,Other...], 这里要加到最前面,我的自定义规则优先
2. 读取`template.json`文件中的`ruleProviders`加到`config["rule-providers"]`中
3. 读取`template.json`文件中的`v6Domains`, 后面代码使用
4. 在`main`函数`return config`前加上以下代码:

```javascript
// json中读取`ruleSet`, `ruleProviders`, `v6Domains`

config.rules = [...ruleSet, ...config.rules];

Object.keys(ruleProviders).forEach(function (key) {
  config["rule-providers"][key] = ruleProviders[key];
});

config.ipv6 = true;
config.dns.ipv6 = true;
var domesticDoH = [
  "https://dns.alidns.com/dns-query",
  "https://doh.pub/dns-query",
];
const ipv6Doh = [
  "https://[2402:4e00::]/dns-query",
  "https://[2400:3200::1]/dns-query",
];
const mixedDns = [...domesticDoH, ...ipv6Doh];
// 这里v6Domains就是从json中读取的
v6Domains.forEach(function (host) {
  if (!config.dns["nameserver-policy"][host]) {
    config.dns["nameserver-policy"][host] = mixedDns.slice();
  }
});
v6Domains.forEach(function (domain) {
  if (!config.dns["fake-ip-filter"].includes(domain)) {
    config.dns["fake-ip-filter"].push(domain);
  }
});
```
