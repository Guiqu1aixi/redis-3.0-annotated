# Kiro IDE Redis调试指南

## 问题说明

在Mac Silicon上使用Kiro IDE时，`C/C++ Debug (gdb)` 插件不可用。这是因为：
1. Mac Silicon (Apple M1/M2) 对GDB支持有限
2. Kiro可能没有包含某些VSCode插件
3. macOS推荐使用LLDB而不是GDB

## 解决方案

### 方案1: 使用Kiro内置调试功能

1. **检查Kiro是否支持LLDB调试**
   - 按 `Cmd+Shift+P` 打开命令面板
   - 输入 "Debug" 查看可用的调试选项
   - 查找 "LLDB" 或 "Native Debug" 选项

2. **手动配置调试**
   ```json
   {
       "name": "Debug Redis",
       "type": "lldb",
       "request": "launch",
       "program": "${workspaceFolder}/src/redis-server",
       "args": ["${workspaceFolder}/redis.conf"],
       "cwd": "${workspaceFolder}"
   }
   ```

### 方案2: 使用终端调试 (推荐)

1. **运行调试脚本**
   ```bash
   ./debug_redis_kiro.sh
   ```

2. **直接使用LLDB**
   ```bash
   # 编译调试版本
   make CFLAGS="-g -O0"
   
   # 启动LLDB调试
   lldb src/redis-server -- redis.conf
   ```

3. **LLDB基本命令**
   ```bash
   (lldb) b main                    # 在main函数设置断点
   (lldb) b redis.c:2008           # 在指定行设置断点
   (lldb) b processCommand         # 在函数设置断点
   (lldb) run                      # 运行程序
   (lldb) n                        # 下一行
   (lldb) s                        # 单步进入
   (lldb) c                        # 继续执行
   (lldb) p server                 # 打印变量
   (lldb) bt                       # 查看调用栈
   ```

### 方案3: 使用Kiro的终端调试功能

1. **在Kiro中打开终端**
   - `View` -> `Terminal` 或 `Ctrl+`` 

2. **在终端中运行调试命令**
   ```bash
   lldb src/redis-server -- redis.conf
   ```

3. **设置断点并调试**
   ```bash
   (lldb) b main
   (lldb) run
   ```

### 方案4: 混合调试方式

1. **在Kiro中查看和编辑代码**
2. **在终端中进行调试**
3. **利用Kiro的语法高亮和代码导航功能**

## 推荐的调试流程

### 1. 准备工作
```bash
# 编译调试版本
make CFLAGS="-g -O0"

# 生成调试符号
dsymutil src/redis-server
```

### 2. 设置关键断点
```bash
lldb src/redis-server -- redis.conf

# 在LLDB中设置断点
(lldb) b main                    # 程序入口
(lldb) b initServer             # 服务器初始化
(lldb) b processCommand         # 命令处理
(lldb) b readQueryFromClient    # 网络处理
```

### 3. 开始调试
```bash
(lldb) run                      # 启动程序
# 程序会在断点处停止
(lldb) n                        # 单步执行
(lldb) p server.port           # 查看变量
(lldb) bt                       # 查看调用栈
```

### 4. 测试Redis功能
在另一个终端中：
```bash
./src/redis-cli
> SET test "hello"
> GET test
```

## 常见问题解决

### 1. 如果LLDB不可用
```bash
# 安装Xcode Command Line Tools
xcode-select --install
```

### 2. 如果调试符号缺失
```bash
# 重新生成调试符号
dsymutil src/redis-server
```

### 3. 如果Kiro不支持调试
- 使用终端进行调试
- 在Kiro中查看和编辑代码
- 利用Kiro的代码导航功能

## 调试技巧

1. **使用日志调试**
   - 在代码中添加printf语句
   - 查看Redis的日志输出

2. **分步调试**
   - 先在main函数设置断点
   - 逐步深入到具体功能

3. **查看内存和变量**
   ```bash
   (lldb) p *server               # 查看结构体
   (lldb) x/10x ptr              # 查看内存
   (lldb) memory read ptr        # 读取内存
   ```

## 总结

虽然Kiro可能不支持某些VSCode插件，但我们可以：
1. 使用LLDB进行命令行调试
2. 利用Kiro的代码编辑功能
3. 结合终端和IDE的优势
4. 通过脚本简化调试流程

这样既能享受Kiro的代码编辑体验，又能进行有效的调试。