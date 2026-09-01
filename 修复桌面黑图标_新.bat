@echo off
chcp 65001 >nul
title 修复桌面黑图标工具
color 0A

:: 检查是否以管理员权限运行，如果没有则尝试提权
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 正在请求管理员权限...
    powershell -Command "Start-Process '%~f0' -Verb RunAs"
    exit /b
)

echo ========================================
echo           桌面黑图标修复工具
echo ========================================
echo.
echo 正在清理图标缓存，请稍候...
echo.

:: 结束 Windows 资源管理器
taskkill /f /im explorer.exe >nul 2>&1
timeout /t 1 /nobreak >nul

:: 删除主图标缓存
cd /d "%userprofile%\AppData\Local"
if exist "IconCache.db" (
    del /a /f /q "IconCache.db" >nul 2>&1
)

:: 删除 Explorer 目录下的所有图标和缩略图缓存
del /a /f /q "%localappdata%\Microsoft\Windows\Explorer\iconcache*" >nul 2>&1
del /a /f /q "%localappdata%\Microsoft\Windows\Explorer\thumbcache*" >nul 2>&1

:: 额外清理
del /a /f /q "%localappdata%\IconCache.db" >nul 2>&1

timeout /t 1 /nobreak >nul

:: 重新启动资源管理器
start "" explorer.exe

echo.
echo ========================================
echo  修复完成！桌面图标应该已经恢复正常。
echo ========================================
echo.
echo 如果图标仍未完全显示，请稍等几秒或按 F5 刷新桌面。
echo.
echo 按任意键退出...
pause >nul