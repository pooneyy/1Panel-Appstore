#!/usr/bin/env python3
import os
import re
import shutil
import sys
import yaml

def extract_version_from_string(input_string) -> dict:
    """
    从字符串中提取版本号，支持镜像名和文件夹名
    
    Args:
        input_string (str): 可以是Docker镜像名或文件夹名
        
    Returns:
        dict: 包含提取结果的字典 {success: bool, version: str}
    """
    if ':' in input_string:
        parts = input_string.split(':')
        candidate = parts[-1]
    else:
        candidate = os.path.basename(input_string)
    
    # 保存原始候选字符串用于失败时返回
    original_candidate = candidate
    
    # 从复杂标签中提取包含数字和分隔符的版本号部分
    pattern = r'(\d+(?:[\.\-]\d+)+)'
    matches = re.findall(pattern, candidate)
    if matches:
        # 选择最长的匹配项，并统一分隔符为点号
        best_match = max(matches, key=len)
        normalized_version = re.sub(r'[\.\-]', '.', best_match)
        return {"success": True, "version": normalized_version}
    
    return {"success": False, "version": original_candidate}

def replace_version_in_dirname(old_ver_dir : str, new_version : str) -> str:
    """
    将旧版本文件夹名中的版本号替换为新版本号
    
    Args:
        old_ver_dir (str): 旧版本文件夹名
        new_version (str): 新版本号
        
    Returns:
        str: 新版本文件夹名
    """
    version_info = extract_version_from_string(old_ver_dir)
    
    if version_info["success"]:
        old_version = version_info["version"]
        new_ver_dir = old_ver_dir.replace(old_version, new_version)
        return new_ver_dir
    else:
        return new_version

def check_directory_contents(check_dir):
    print(f"{check_dir} 目录内容:")
    for item in os.listdir(check_dir):
        print(f"  - {item}")

def safe_rename_directory(old_path: str, new_path: str) -> bool:
    """
    安全地重命名目录，包含错误处理
    
    Args:
        old_path (str): 原目录路径
        new_path (str): 新目录路径
        
    Returns:
        bool: 重命名是否成功
    """
    try:
        if not os.path.exists(old_path):
            print(f"错误: 原目录不存在: {old_path}")
            return False
            
        if os.path.exists(new_path):
            print(f"错误: 目标目录已存在: {new_path}")
            return False
            
        print(f"将 {old_path} 重命名为 {new_path}")
        shutil.move(old_path, new_path)
        
        # 验证重命名是否成功
        if os.path.exists(new_path) and not os.path.exists(old_path):
            check_directory_contents(new_path)
            print(f"✓ 重命名成功")
            return True
        else:
            print(f"✗ 重命名后验证失败")
            return False
            
    except PermissionError as e:
        print(f"✗ 权限错误: {e}")
        return False
    except OSError as e:
        print(f"✗ 系统错误: {e}")
        return False
    except Exception as e:
        print(f"✗ 未知错误: {e}")
        return False

def write_version_file(file_path: str, version: str) -> bool:
    """
    写入版本标记文件
    
    Args:
        file_path (str): 版本标记文件路径
        version (str): 版本号
        
    Returns:
        bool: 写入是否成功
    """
    try:
        os.makedirs(os.path.dirname(file_path), exist_ok=True)
        with open(file_path, 'w') as f:
            f.write(version)
        print(f"✓ 版本标记文件已更新: {file_path}")
        return True
    except Exception as e:
        print(f"✗ 写入版本标记文件失败: {e}")
        return False

def main():
    app_name = sys.argv[1]
    old_ver_dir = sys.argv[2]
    
    docker_compose_file = f"apps/{app_name}/{old_ver_dir}/docker-compose.yml"
    
    if not os.path.exists(docker_compose_file):
        print(f"错误: 文件 {docker_compose_file} 不存在")
        sys.exit(1)
    
    with open(docker_compose_file, 'r') as f:
        compose_data = yaml.safe_load(f)
    
    services = compose_data.get('services', {})

    first_service = list(services.keys())[0]
    print(f"第一个服务是: {first_service}")
    
    image = services[first_service].get('image', '')
    print(f"该服务的镜像: {image}")
    
    new_version : str = extract_version_from_string(image).get("version", "latest")
    old_version : str = extract_version_from_string(old_ver_dir).get("version", "latest")
    print(f"旧版本号: {old_version}")
    print(f"新版本号: {new_version}")
    new_ver_dir = replace_version_in_dirname(old_ver_dir, new_version)
    if old_version != new_version:
        old_path = f"apps/{app_name}/{old_ver_dir}"
        new_path = f"apps/{app_name}/{new_ver_dir}"
        
        if safe_rename_directory(old_path, new_path):
            # 更新版本标记文件
            version_file = f"apps/{app_name}/{old_version}.version"
            if not write_version_file(version_file, new_version):
                print("版本标记文件更新失败，但目录重命名成功")
        else:
            print("错误: 目录重命名失败")
            sys.exit(1)

if __name__ == "__main__":
    main()