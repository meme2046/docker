# 依赖安装

1. ffmpeg音频转换: `scoop install -g ffmpeg-essentials`
2. 编辑信息, 设置封面, 有GUI: `scoop install -g tageditor`

# 使用

1. 转换为opus格式: `nu ff.nu to-opus`
2. 添加封面(依赖tageditor): `nu ff.nu te-cover`
3. 打印标签(依赖tageditor): `nu ff.nu te-tag`
4. 从路径提取episode和title信息: `nu ff.nu parse-episode`

# tmp

```shell
nu ff.nu metadata-parse 'd:/AudioBooks/大奉打更人_头陀渊_1750集完/大奉打更人 第0005集 解开谜题.mp3'
nu ff.nu metadata-parse 'd:/AudioBooks/凡人修仙传_光合积木/凡人修仙传 • 第001集 二愣子.m4a'
nu ff.nu metadata-parse 'd:/AudioBooks/诡秘之主_8082Audio_2059集完/0001-0500/0001.m4a'
```
