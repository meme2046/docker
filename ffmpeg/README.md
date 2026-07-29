# 依赖安装

1. ffmpeg音频转换: `scoop install -g ffmpeg-essentials`
2. 编辑信息, 设置封面, 有GUI: `scoop install -g tageditor`

# 使用

1. 转换为opus格式: `nu ff.nu to-opus`
2. 添加封面(依赖tageditor): `nu ff.nu te-cover`
3. 打印标签(依赖tageditor): `nu ff.nu te-tag`
4. 从路径提取episode和title信息: `nu ff.nu parse-episode`
