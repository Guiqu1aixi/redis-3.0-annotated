# Redis 本地编译和调试完整指南

## 环境要求

- macOS (已在Apple Silicon上测试)
- Xcode Command Line Tools
- VSCode (推荐) + C/C++ 扩展
- LLDB (系统自带)

## 快速开始

### 1. 编译调试版本
```bash
# 使用调试专用Makefile
make -f Makefile.debug debug

# 或者使用标准方式
make CFLAGS="-g -O0"
```

### 2. 启动调试

#### 方式一：VSCode调试 (推荐)
1. 在VSCode中打开项目
2. 按 `F5` 或点击调试按钮
3. 选择 "Debug Redis Server" 配置

#### 方式二：LLDB命令行调试
```bash
# 使用调试脚本
./debug_redis.sh

# 或直接使用LLDB
lldb src/redis-server -- redis.conf
```

#### 方式三：使用调试Makefile
```bash
make -f Makefile.debug lldb-debug
```

## 调试配置说明

### VSCode配置文件

- `.vscode/launch.json` - 调试启动配置
- `.vscode/tasks.json` - 构建任务配置  
- `.vscode/settings.json` - C/C++智能感知配置

### 重要的调试断点

1. **程序入口**: `main()` (redis.c:3800)
2. **服务器初始化**: `initServer()` (redis.c:2008)
3. **命令处理**: `processCommand()` (redis.c)
4. **网络处理**: `readQueryFromClient()` (networking.c)
5. **内存管理**: `zmalloc()`, `zfree()` (zmalloc.c)

## 常用调试命令

### LLDB基本命令
```bash
# 设置断点
(lldb) b main
(lldb) b redis.c:2008
(lldb) b processCommand

# 运行和控制
(lldb) run
(lldb) continue
(lldb) next
(lldb) step

# 查看变量和内存
(lldb) p server
(lldb) p *c
(lldb) x/10x ptr
```

### 查看Redis内部状态
```bash
# 服务器状态
(lldb) p server.port
(lldb) p server.dbnum
(lldb) p server.clients

# 客户端信息
(lldb) p c->fd
(lldb) p c->querybuf
(lldb) p c->argc
```

## 测试和验证

### 1. 基本功能测试
```bash
# 启动服务器
./src/redis-server redis.conf

# 在另一个终端测试
./src/redis-cli
> SET test "hello"
> GET test
> INCR counter
```

### 2. 使用测试客户端
```bash
# 编译测试客户端
gcc -o test_client test_client.c

# 运行测试
./test_client
```

### 3. 性能测试
```bash
./src/redis-benchmark -n 10000 -c 50
```

## 调试技巧

### 1. 调试命令处理流程
- 在 `processCommand()` 设置断点
- 观察 `c->argc` 和 `c->argv` 参数解析
- 跟踪具体命令函数执行

### 2. 调试内存问题
- 在 `zmalloc()` 和 `zfree()` 设置断点
- 使用 `info malloc` 查看内存使用
- 检查对象引用计数

### 3. 调试网络问题
- 在 `acceptTcpHandler()` 设置断点
- 观察客户端连接建立过程
- 检查数据读写流程

### 4. 调试数据结构
- 在字典操作函数设置断点
- 观察哈希表扩容过程
- 检查数据类型转换

## 故障排除

### 编译问题
- 确保安装了Xcode Command Line Tools
- 检查是否有ARM64兼容性问题
- 查看编译警告和错误信息

### 调试问题
- 确保编译时包含了调试信息 (`-g` 选项)
- 检查调试符号是否正确生成 (`.dSYM` 文件)
- 验证LLDB是否能正确加载符号

### 运行问题
- 检查端口是否被占用
- 确认配置文件路径正确
- 查看Redis日志输出

## 高级调试

### 内存分析
```bash
# 使用Instruments (macOS)
make -f Makefile.debug profile

# 使用Valgrind (需要安装)
make -f Makefile.debug valgrind-debug
```

### 性能分析
- 使用Instruments的Time Profiler
- 分析CPU热点函数
- 检查内存分配模式

## 文件说明

- `redis.conf` - Redis配置文件
- `debug_redis.sh` - 调试辅助脚本
- `debug_commands.md` - 详细调试命令参考
- `test_client.c` - 简单测试客户端
- `Makefile.debug` - 调试专用构建文件

## 参考资源

- [Redis源码分析](http://redisbook.com/)
- [LLDB调试指南](https://lldb.llvm.org/use/tutorial.html)
- [VSCode C++调试](https://code.visualstudio.com/docs/cpp/cpp-debug)

---

现在你已经有了一个完整的Redis本地编译和调试环境！可以开始深入研究Redis的内部实现了。