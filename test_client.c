#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define REDIS_PORT 6379
#define BUFFER_SIZE 1024

int connect_to_redis() {
    int sock;
    struct sockaddr_in server_addr;
    
    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        perror("socket creation failed");
        return -1;
    }
    
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(REDIS_PORT);
    server_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
    
    if (connect(sock, (struct sockaddr*)&server_addr, sizeof(server_addr)) < 0) {
        perror("connection failed");
        close(sock);
        return -1;
    }
    
    return sock;
}

void send_command(int sock, const char* command) {
    char buffer[BUFFER_SIZE];
    
    printf("发送命令: %s", command);
    send(sock, command, strlen(command), 0);
    
    int bytes_received = recv(sock, buffer, BUFFER_SIZE - 1, 0);
    if (bytes_received > 0) {
        buffer[bytes_received] = '\0';
        printf("响应: %s\n", buffer);
    }
}

int main() {
    int sock = connect_to_redis();
    if (sock < 0) {
        printf("无法连接到Redis服务器\n");
        return 1;
    }
    
    printf("已连接到Redis服务器\n");
    
    // 测试基本命令
    send_command(sock, "PING\r\n");
    send_command(sock, "*3\r\n$3\r\nSET\r\n$4\r\ntest\r\n$5\r\nhello\r\n");
    send_command(sock, "*2\r\n$3\r\nGET\r\n$4\r\ntest\r\n");
    send_command(sock, "*2\r\n$4\r\nINCR\r\n$7\r\ncounter\r\n");
    send_command(sock, "*2\r\n$3\r\nGET\r\n$7\r\ncounter\r\n");
    
    close(sock);
    printf("连接已关闭\n");
    return 0;
}