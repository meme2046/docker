#!/bin/bash
# 测试文件存在性及内容校验
test -f "config.json" && echo "JSON文件存在" || echo "JSON文件缺失"
test -f "config.yaml" && echo "YAML文件存在" || echo "YAML文件缺失"

# 使用jq解析JSON示例
jq '.username' config.json > /dev/null 2>&1
if [ $? -eq 0 ]; then
  echo "JSON解析成功"
else
  echo "JSON解析失败"
fi

# 使用shyaml解析YAML示例
yaml_content=$(cat config.yaml)
eval $(shyaml parse <<< "$yaml_content")
echo "YAML解析结果: $username"
