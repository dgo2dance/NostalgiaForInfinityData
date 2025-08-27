#!/usr/bin/env python3
# 文件名：view_feather_fixed_path.py

import pandas as pd

# 把这里的路径改成你自己的文件路径
FILE_PATH = "./binance/BTC_USDT-1h.feather"

def main():
    print(f"📁 正在读取 Feather 文件: {FILE_PATH}\n")
    # 读取 .feather 文件
    df = pd.read_feather(FILE_PATH)

    # 打印 DataFrame 的基本信息
    print("=== DataFrame 信息 ===")
    # df.info() 本身就会输出到 stdout，所以直接调用即可
    df.info()

    # 打印前 5 行
    print("\n=== 前 5 行 ===")
    print(df.head())
    print(df.tail())


    # 如果想看全部数据，可以把下面这行取消注释
    # print("\n=== 全部数据 ===\n", df)

if __name__ == "__main__":
    main()
