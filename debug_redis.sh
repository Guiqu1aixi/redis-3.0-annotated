#!/bin/bash

# Redis调试辅助脚本

echo "Redis调试环境设置脚本"
echo "====================="

# 检查编译状态
if [ ! -f "src/redis-server" ]; then
    echo "❌ Redis服务器未编译，正在编译..."
    make CFLAGS="-g -O0"
    if [ $? -ne 0 ]; then
        echo "❌ 编译失败"
        exit 1
    fi
    echo "✅ 编译完成"
else
    echo "✅ Redis服务器已编译"
fi

# 检查调试符号
if [ -d "src/redis-server.dSYM" ]; then
    echo "✅ 调试符号已生成"
else
    echo "⚠️  正在生成调试符号..."
    dsymutil src/redis-server
    echo "✅ 调试符号生成完成"
fi

# 显示可用的调试选项
echo ""
echo "可用的调试选项："
echo "1. 使用VSCode调试 (推荐)"
echo "2. 使用LLDB命令行调试"
echo "3. 使用GDB调试 (如果安装了)"
echo "4. 运行Redis服务器进行手动测试"
echo ""

read -p "请选择选项 (1-4): " choice

case $choice in
    1)
        echo "启动VSCode调试..."
        echo "请在VSCode中按F5或使用调试面板启动'Debug Redis Server'配置"
        code .
        ;;
    2)
        echo "启动LLDB调试..."
        lldb src/redis-server -- redis.conf
        ;;
    3)
        if command -v gdb &> /dev/null; then
            echo "启动GDB调试..."
            gdb --args src/redis-server redis.conf
        else
            echo "❌ GDB未安装，请使用其他选项"
        fi
        ;;
    4)
        echo "启动Redis服务器..."
        ./src/redis-server redis.conf
        ;;
    *)
        echo "无效选项"
        exit 1
        ;;
esac