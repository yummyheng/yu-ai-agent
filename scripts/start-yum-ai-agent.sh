#!/bin/sh
# Summary: yum-ai-agent 后端运维入口（start/stop/restart/status，Spring Boot 8123）——编译门禁+后台启动+health 就绪探针，日志落 tmp/java-logs-backend/；密钥经 spring.config.import 读 ~/.orchestrator-secrets.yaml（占位符解析）。
# Script-Role: standalone

set -eu

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
WORKSPACE_ROOT=$(CDPATH= cd -- "${SCRIPT_DIR}/.." && pwd)
BACKEND_DIR="${WORKSPACE_ROOT}/yum-ai-agent-backend"
LOG_DIR="${WORKSPACE_ROOT}/tmp/java-logs-backend"
LOG_FILE="${LOG_DIR}/app.log"
BACKEND_PORT=8123
HEALTH_URL="http://localhost:${BACKEND_PORT}/api/health"
READY_TIMEOUT_SEC=150   # vectorStore bean 启动期对 3 篇知识库 md 做 AI 富化+向量化（远程调用），慢启动属预期
PID_FILE="${LOG_DIR}/app.pid"

SCRIPT_NAME=$(basename "$0")
START_EPOCH=$(date '+%s')

print_usage() {
  cat <<EOF
用法：sh ${SCRIPT_NAME} [start|stop|restart|status] [--rebuild]

  start     编译（增量；--rebuild 强制 clean 全量）后后台启动，轮询 /api/health 至就绪
  stop      停止运行中的后端（mvn spring-boot:run 进程树）
  restart   stop 后 start
  status    探针健康检查（HTTP 码回显）
  --rebuild 启动前 mvn clean compile（源码/依赖变更后用）

说明：JDK 用本机缺省（JDK 24 编 release 21，lombok 已升 1.18.46 适配）；
     模型面=智谱 glm-5.3-flash（key 占位符化，真值在 ~/.orchestrator-secrets.yaml）。
EOF
}

do_status() {
  code=$(curl -s -m 3 -o /dev/null -w '%{http_code}' "${HEALTH_URL}" 2>/dev/null || true)
  echo "status: http=${code:-000} url=${HEALTH_URL}"
  [ "${code:-000}" = "200" ]
}

do_stop() {
  echo "==> 停止 yum-ai-agent 后端 ..."
  pkill -f 'spring-boot:run.*yum-ai-agent' 2>/dev/null || true
  pkill -f "com.yupi.yuaiagent" 2>/dev/null || true
  for _ in 1 2 3 4 5; do
    code=$(curl -s -m 2 -o /dev/null -w '%{http_code}' "${HEALTH_URL}" 2>/dev/null || true)
    [ "${code:-000}" = "000" ] && break
    sleep 1
  done
  rm -f "${PID_FILE}"
  echo "==> 已停止"
}

do_start() {
  mkdir -p "${LOG_DIR}"
  if code=$(curl -s -m 2 -o /dev/null -w '%{http_code}' "${HEALTH_URL}" 2>/dev/null || true) && [ "${code:-000}" = "200" ]; then
    echo "==> 已在运行（${HEALTH_URL}=200），跳过启动；如需重启用 restart"
    return 0
  fi
  REBUILD_FLAG=${REBUILD_FLAG:-0}
  cd "${BACKEND_DIR}"
  if [ "${REBUILD_FLAG}" = "1" ]; then
    echo "==> mvn clean compile（--rebuild 全量）..."
    mvn -DskipTests clean compile -q
  else
    echo "==> mvn compile（增量）..."
    mvn -DskipTests compile -q
  fi
  echo "==> 后台启动（日志 ${LOG_FILE}）..."
  nohup mvn -q spring-boot:run >> "${LOG_FILE}" 2>&1 &
  echo $! > "${PID_FILE}"
  i=0
  while [ "${i}" -lt "${READY_TIMEOUT_SEC}" ]; do
    code=$(curl -s -m 2 -o /dev/null -w '%{http_code}' "${HEALTH_URL}" 2>/dev/null || true)
    if [ "${code:-000}" = "200" ]; then
      echo "==> 就绪 health=200（~${i}s）——验证：curl ${HEALTH_URL}"
      return 0
    fi
    sleep 1
    i=$((i + 1))
  done
  echo "==> 超时（>${READY_TIMEOUT_SEC}s）未就绪；排障：tail -50 ${LOG_FILE}" >&2
  return 1
}

ACTION="start"
REBUILD_FLAG=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    start|stop|restart|status) ACTION=$1 ; shift ;;
    --rebuild) REBUILD_FLAG=1 ; shift ;;
    -h|--help) print_usage ; exit 0 ;;
    *) echo "未知参数: $1" >&2 ; print_usage >&2 ; exit 1 ;;
  esac
done

export REBUILD_FLAG
printf '==> START %s action=%s rebuild=%s\n' "${SCRIPT_NAME}" "${ACTION}" "${REBUILD_FLAG}"

case "${ACTION}" in
  start) do_start ;;
  stop) do_stop ;;
  restart) do_stop ; do_start ;;
  status) do_status ;;
esac
RC=$?

END_EPOCH=$(date '+%s')
printf '==> END %s duration_sec=%s exit_code=%s\n' "${SCRIPT_NAME}" "$((END_EPOCH - START_EPOCH))" "${RC}"
exit "${RC}"

# Validate: python3 /Users/hengzai/orchestrator/scripts/validate_sh_script.py --write-header-status /Users/hengzai/javaAIProject/yum-ai-agent/scripts/start-yum-ai-agent.sh
# Related: ../README.md, ../project_docs/后端功能设计/LoveApp域/RAG增强链设计.md
# Validation-Status: pending  # sh -n 过 + 校验器对工作区外路径 autogen 对拍崩溃（ValueError 边界 bug 留过程发现），功能验证=脚本实跑
