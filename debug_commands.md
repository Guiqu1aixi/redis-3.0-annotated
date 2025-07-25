# Redis调试常用命令和断点

## 重要的调试断点位置

### 1. 服务器启动相关
- `main()` - redis.c:3800 (程序入口)
- `initServerConfig()` - redis.c:1678 (初始化服务器配置)
- `initServer()` - redis.c:2008 (初始化服务器)

### 2. 网络处理相关
- `acceptTcpHandler()` - networking.c (接受TCP连接)
- `readQueryFromClient()` - networking.c (读取客户端查询)
- `processCommand()` - redis.c (处理命令)

### 3. 数据结构操作
- `lookupKey()` - db.c (查找键)
- `setKey()` - db.c (设置键值)
- `dbAdd()` - db.c (添加键到数据库)
- `dbDelete()` - db.c (从数据库删除键)

### 4. 内存管理
- `zmalloc()` - zmalloc.c (内存分配)
- `zfree()` - zmalloc.c (内存释放)

### 5. 持久化相关
- `rdbSave()` - rdb.c (RDB保存)
- `rdbLoad()` - rdb.c (RDB加载)
- `feedAppendOnlyFile()` - aof.c (AOF写入)

## LLDB调试命令

### 基本命令
```bash
# 启动调试
lldb src/redis-server -- redis.conf

# 设置断点
(lldb) b main
(lldb) b redis.c:2008
(lldb) b processCommand

# 运行程序
(lldb) run

# 查看变量
(lldb) p server
(lldb) p *c
(lldb) p cmd->name

# 查看调用栈
(lldb) bt

# 单步执行
(lldb) n  # next line
(lldb) s  # step into
(lldb) c  # continue

# 查看内存
(lldb) x/10x ptr
(lldb) memory read --size 4 --format x --count 10 ptr
```

### Redis特定调试
```bash
# 查看Redis服务器状态
(lldb) p server.port
(lldb) p server.dbnum
(lldb) p server.clients

# 查看客户端信息
(lldb) p c->fd
(lldb) p c->querybuf
(lldb) p c->argc
(lldb) p c->argv[0]->ptr

# 查看数据库状态
(lldb) p server.db[0].dict
(lldb) p server.db[0].expires
```

## 测试用例

### 基本功能测试
```bash
# 启动Redis服务器后，在另一个终端运行：
./src/redis-cli

# 测试基本命令
SET key1 "hello"
GET key1
INCR counter
LPUSH list1 "item1" "item2"
LRANGE list1 0 -1
```

### 性能测试
```bash
# 使用redis-benchmark进行压力测试
./src/redis-benchmark -n 10000 -c 50
```

## VSCode调试技巧

1. 在VSCode中打开项目
2. 设置断点：点击行号左侧
3. 按F5启动调试
4. 使用调试控制台查看变量
5. 使用监视窗口添加表达式

## 常见调试场景

### 1. 调试命令处理流程
断点设置在：
- `processCommand()` - 命令处理入口
- 具体命令函数，如 `setCommand()`, `getCommand()`

### 2. 调试内存问题
断点设置在：
- `zmalloc()`, `zfree()` - 内存分配/释放
- `createObject()`, `decrRefCount()` - 对象创建/销毁

### 3. 调试网络问题
断点设置在：
- `acceptTcpHandler()` - 连接接受
- `readQueryFromClient()` - 数据读取
- `addReply()` - 响应发送

### 4. 调试数据结构
断点设置在：
- `dictAdd()`, `dictFind()` - 字典操作
- `listAddNodeHead()`, `listDelNode()` - 链表操作
- `zslInsert()`, `zslDelete()` - 跳跃表操作