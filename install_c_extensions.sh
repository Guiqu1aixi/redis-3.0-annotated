#!/bin/bash

echo "🚀 VSCode C语言开发环境自动安装脚本"
echo "=================================="

# 检查VSCode是否安装
if ! command -v code &> /dev/null; then
    echo "❌ VSCode未安装或未添加到PATH"
    echo "请先安装VSCode并确保'code'命令可用"
    exit 1
fi

echo "✅ 检测到VSCode"

# 必需插件列表
REQUIRED_EXTENSIONS=(
    "ms-vscode.cpptools-extension-pack"  # C/C++ Extension Pack
    "formulahendry.code-runner"          # Code Runner
    "jeff-hykin.better-cpp-syntax"       # Better C++ Syntax
    "hars.CppSnippets"                   # C/C++ Snippets
    "CoenraadS.bracket-pair-colorizer-2" # Bracket Pair Colorizer 2
    "oderwat.indent-rainbow"             # indent-rainbow
    "usernamehw.errorlens"               # Error Lens
)

# 推荐插件列表
RECOMMENDED_EXTENSIONS=(
    "ms-vscode.hexeditor"                # Hex Editor (调试内存时有用)
    "ms-vscode.vscode-json"              # JSON支持
    "redhat.vscode-yaml"                 # YAML支持
    "ms-vscode.makefile-tools"           # Makefile支持
    "twxs.cmake"                         # CMake语法支持
    "ms-vscode.cmake-tools"              # CMake工具
)

echo ""
echo "📦 开始安装必需插件..."
echo ""

for extension in "${REQUIRED_EXTENSIONS[@]}"; do
    echo "正在安装: $extension"
    code --install-extension "$extension" --force
    if [ $? -eq 0 ]; then
        echo "✅ $extension 安装成功"
    else
        echo "❌ $extension 安装失败"
    fi
    echo ""
done

echo ""
read -p "是否安装推荐插件? (y/n): " install_recommended

if [[ $install_recommended =~ ^[Yy]$ ]]; then
    echo ""
    echo "📦 开始安装推荐插件..."
    echo ""
    
    for extension in "${RECOMMENDED_EXTENSIONS[@]}"; do
        echo "正在安装: $extension"
        code --install-extension "$extension" --force
        if [ $? -eq 0 ]; then
            echo "✅ $extension 安装成功"
        else
            echo "❌ $extension 安装失败"
        fi
        echo ""
    done
fi

echo ""
echo "🎉 插件安装完成!"
echo ""
echo "接下来的步骤:"
echo "1. 重启VSCode"
echo "2. 打开C项目文件夹"
echo "3. 配置编译器路径"
echo "4. 开始编写和调试C代码"
echo ""
echo "💡 提示: 运行 './setup_c_workspace.sh' 来创建一个示例C项目"