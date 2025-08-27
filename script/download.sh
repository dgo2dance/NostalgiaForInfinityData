#!/usr/bin/env bash
set -eo pipefail

# 打开 nullglob，确保没有匹配到时 for 循环不会把字面字符串当文件名
shopt -s nullglob
echo "download begin"
pwd
ls

# 遍历所有 backtesting-*.env 文件
for envfile in /freqtrade/backtesting-*.env; do
  echo
  echo "=============================="
  echo "⏳  处理环境变量文件：${envfile}"
  echo "=============================="

  # 清除上一轮可能残留的变量
  unset START_DATE END_DATE EXCHANGE TRADINGMODE PROXY HTTP_PROXY

  # 导出该 env 文件里的所有变量
  set -a
  source "${envfile}"
  set +a

  # 检查必要变量是否存在
  if [[ -z "${START_DATE:-}" || -z "${END_DATE:-}" || -z "${EXCHANGE:-}" || -z "${TRADINGMODE:-}" ]]; then
    echo "❌  文件 ${envfile} 中缺少 START_DATE/END_DATE/EXCHANGE/TRADINGMODE，跳过"
    continue
  fi

  echo "➡️  开始下载：${EXCHANGE} / ${TRADINGMODE}"
  echo "   时间区间：${START_DATE} → ${END_DATE}"

  # 如果是 Binance，需要设置代理
#   if [[ "${EXCHANGE}" == "binance" ]]; then
#     # env 文件中可以定义 PROXY=http://...
#     export HTTP_PROXY="${PROXY:-}"
#     echo "   使用 HTTP_PROXY=${HTTP_PROXY}"
#   fi

  # 真正调用 freqtrade 的下载命令
  # 下载出的文件会放到 /freqtrade/user_data/data/${EXCHANGE}
  download-data \
    --timerange "${START_DATE}-${END_DATE}" \
    --timeframe 5m 15m 1h 4h 1d \
    --datadir user_data/data/"${EXCHANGE}" \
    --config user_data/data/pairlists.json \
    --config user_data/data/"${EXCHANGE}"-"${TRADINGMODE}"-usdt-static.json

  # 修正一下文件属主，避免宿主机看到 root 拥有
  echo "➡️  修正权限：user_data/data/${EXCHANGE}"
  chown -R "$(id -u):$(id -g)" user_data/data/"${EXCHANGE}"

  echo "✅  完成：${EXCHANGE} / ${TRADINGMODE}"
done

echo
echo "🏁  所有 backtesting-*.env 均处理完毕！"
