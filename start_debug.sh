#!/bin/bash

# 简单的Redis调试启动器
echo "🔧 Redis调试启动器"
echo "=================="

# 确保编译了调试版本
if [ ! -f "src/redis-server" ]; then
    echo "正在编译调试版本..."
    make CFLAGS="-g -O0"
fi

# 生成调试符号
if [ ! -d "src/redis-server.dSYM" ]; then
    dsymutil src/redis-server
fi

echo ""
echo "🚀 启动LLDB调试Redis..."
echo ""
echo "建议的调试步骤:"
echo "1. (lldb) b main"
echo "2. (lldb) run"
echo "3. (lldb) n  # 单步执行"
echo "4. (lldb) p server  # 查看服务器状态"
echo ""

# 启动LLDB
exec lldb src/redis-server -- redis.conf