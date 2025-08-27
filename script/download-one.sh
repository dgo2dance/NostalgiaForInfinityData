#!/usr/bin/env bash
set -euo pipefail

# 1. 指定只处理这一份 env 文件
ENV_FILE=/freqtrade/user_data/data/backtesting-binance-spot.env

if [[ ! -f "$ENV_FILE" ]]; then
  echo "❌  找不到环境变量文件：$ENV_FILE"
  exit 1
fi

# 2. 从文件名拆出 EXCHANGE 和 TRADINGMODE
#    backtesting-binance-spot.env → backtesting-binance-spot → binance-spot
base=$(basename "$ENV_FILE" .env)        # backtesting-binance-spot
suffix=${base#backtesting-}              # binance-spot
EXCHANGE=${suffix%-*}                    # binance
TRADINGMODE=${suffix#*-}                 # spot

echo "🔧  交易所: $EXCHANGE"
echo "🔧  模式  : $TRADINGMODE"
echo "🔧  ENV  : $ENV_FILE"

# 3. 导出 START_DATE, END_DATE, （可选 PROXY/HTTP_PROXY）等
set -a
source "$ENV_FILE"
set +a

# 4. 简单校验
if [[ -z "${START_DATE:-}" || -z "${END_DATE:-}" ]]; then
  echo "❌  START_DATE 或 END_DATE 未定义，请检查 $ENV_FILE"
  exit 1
fi

echo "➡️  开始下载 ${EXCHANGE} / ${TRADINGMODE}"
echo "   时间区间：${START_DATE} → ${END_DATE}"

# # 5. （可选）如果需要代理，env 文件里写 PROXY=…，这里自动注入：
# if [[ -n "${PROXY:-}" ]]; then
#   export HTTP_PROXY="$PROXY"
#   echo "   使用 HTTP_PROXY=$HTTP_PROXY"
# fi

# 6. 运行下载命令
freqtrade download-data \
  --timerange "${START_DATE}-${END_DATE}" \
  --timeframe 5m 15m 1h 4h 1d \
  --datadir user_data/data/"${EXCHANGE}" \
  --config user_data/data/pairlists.json \
  --config user_data/data/"${EXCHANGE}"-"${TRADINGMODE}"-usdt-static.json

# 7. 修正权限
echo "➡️  修正权限: user_data/data/${EXCHANGE}"
chown -R "$(id -u):$(id -g)" user_data/data/"${EXCHANGE}"

echo "✅  ${EXCHANGE} / ${TRADINGMODE} 下载完成！"
