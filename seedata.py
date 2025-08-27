#!/usr/bin/env python3
# 文件名：view_feather.py

import sys
import pandas as pd

def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <path/to/file.feather>")
        sys.exit(1)

    fn = sys.argv[1]
    # 读取 feather
    df = pd.read_feather(fn)

    # 打印基本信息
    print("=== DataFrame 信息 ===")
    print(df.info())
    print("\n=== 前 5 行 ===")
    print(df.head())
    # 如果数据量不大，你也可以直接打印全部：
    # print(df)

if __name__ == "__main__":
    main()
