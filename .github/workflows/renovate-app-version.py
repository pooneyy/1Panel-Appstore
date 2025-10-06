#!/usr/bin/env python3
import os
import re
import shutil
import sys
import yaml

def extract_version_from_string(input_string):
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
    
    # 标准的 major.minor.patch 格式（点号分隔）
    pattern1 = r'(\d+\.\d+\.\d+)'
    match1 = re.search(pattern1, candidate)
    if match1:
        return {"success": True, "version": match1.group(1)}
    
    # 连字符分隔的版本号 major-minor-patch
    pattern2 = r'(\d+\-\d+\-\d+)'
    match2 = re.search(pattern2, candidate)
    if match2:
        # 将连字符转换为点号
        version_with_dots = match2.group(1).replace('-', '.')
        return {"success": True, "version": version_with_dots}
    
    # 混合分隔符（如 major.minor-patch）
    pattern3 = r'(\d+[\.\-]\d+[\.\-]\d+)'
    match3 = re.search(pattern3, candidate)
    if match3:
        # 将所有分隔符统一为点号
        version_mixed = match3.group(1)
        version_normalized = re.sub(r'[\.\-]', '.', version_mixed)
        return {"success": True, "version": version_normalized}
    
    # 两个部分的版本号 (major.minor 或 major-minor)
    pattern4 = r'(\d+[\.\-]\d+)(?![\.\-]\d)'  # 确保后面没有第三个数字部分
    match4 = re.search(pattern4, candidate)
    if match4:
        version_two_part = match4.group(1)
        version_normalized = re.sub(r'[\.\-]', '.', version_two_part)
        return {"success": True, "version": version_normalized}
    
    # 从复杂标签中提取包含数字和分隔符的版本号部分
    pattern5 = r'(\d+(?:[\.\-]\d+)+)'
    matches = re.findall(pattern5, candidate)
    if matches:
        # 选择最长的匹配项，并统一分隔符为点号
        best_match = max(matches, key=len)
        normalized_version = re.sub(r'[\.\-]', '.', best_match)
        return {"success": True, "version": normalized_version}
    
    return {"success": False, "version": original_candidate}

def replace_version_in_dirname(old_ver_dir, new_version):
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
        old_version = version_info["original"]
        new_ver_dir = old_ver_dir.replace(old_version, new_version)
        return new_ver_dir
    else:
        return new_version

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
    
    new_version = extract_version_from_string(image)
    print(f"版本号: {new_version}")
    
    old_version = extract_version_from_string(old_ver_dir)
    new_ver_dir = replace_version_in_dirname(old_ver_dir, new_version)
    if old_version != new_version:
        old_path = f"apps/{app_name}/{old_ver_dir}"
        new_path = f"apps/{app_name}/{new_ver_dir}"
        
        if not os.path.exists(new_path):
            print(f"将 {old_path} 重命名为 {new_path}")
            shutil.move(old_path, new_path)
            
            version_file = f"apps/{app_name}/{old_version}.version"
            with open(version_file, 'w') as f:
                f.write(new_version)
        else:
            print(f"错误: {new_path} 文件夹已存在")
            sys.exit(1)

if __name__ == "__main__":
    main()