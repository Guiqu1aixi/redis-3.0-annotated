#!/bin/bash

echo "🔧 Redis调试脚本 (适用于Kiro/Mac Silicon)"
echo "========================================"

# 检查编译状态
if [ ! -f "src/redis-server" ]; then
    echo "❌ Redis服务器未编译，正在编译..."
    make CFLAGS="-g -O0"
    if [ $? -ne 0 ]; then
        echo "❌ 编译失败"
        exit 1
    fi
    echo "✅ 编译完成"
fi

# 生成调试符号
if [ ! -d "src/redis-server.dSYM" ]; then
    echo "🔍 生成调试符号..."
    dsymutil src/redis-server
fi

echo ""
echo "选择调试方式:"
echo "1. LLDB命令行调试 (推荐)"
echo "2. 在Kiro中手动调试"
echo "3. 使用GDB (如果可用)"
echo "4. 简单运行Redis服务器"
echo ""

read -p "请选择 (1-4): " choice

case $choice in
    1)
        echo "🚀 启动LLDB调试..."
        echo ""
        echo "常用LLDB命令:"
        echo "  b main          - 在main函数设置断点"
        echo "  b redis.c:2008  - 在指定行设置断点"
        echo "  run             - 运行程序"
        echo "  n               - 下一行"
        echo "  s               - 单步进入"
        echo "  c               - 继续执行"
        echo "  p variable      - 打印变量"
        echo "  bt              - 查看调用栈"
        echo "  quit            - 退出调试器"
        echo ""
        echo "按回车键启动LLDB..."
        read
        lldb src/redis-server -- redis.conf
        ;;
    2)
        echo "📝 Kiro手动调试步骤:"
        echo ""
        echo "1. 在Kiro中打开 src/redis.c 文件"
        echo "2. 在第2008行 (initServer函数) 点击设置断点"
        echo "3. 按 Cmd+Shift+P 打开命令面板"
        echo "4. 输入 'Debug: Start Debugging'"
        echo "5. 选择 'LLDB' 作为调试器"
        echo "6. 在弹出的配置中输入:"
        echo "   Program: ${PWD}/src/redis-server"
        echo "   Arguments: ${PWD}/redis.conf"
        echo ""
        echo "或者尝试使用终端调试:"
        echo "lldb src/redis-server -- redis.conf"
        ;;
    3)
        if command -v gdb &> /dev/null; then
            echo "🚀 启动GDB调试..."
            gdb --args src/redis-server redis.conf
        else
            echo "❌ GDB未安装"
            echo "在Mac上推荐使用LLDB，选择选项1"
        fi
        ;;
    4)
        echo "🚀 启动Redis服务器..."
        ./src/redis-server redis.conf
        ;;
    *)
        echo "❌ 无效选项"
        exit 1
        ;;
esac