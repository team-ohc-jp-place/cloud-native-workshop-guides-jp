#!/bin/bash

if [ $# != 1 ]; then
    echo "引数にMASTERのURLだけを指定して下さい"
    echo 例 \: $0 https://api.cluster-xxxx.xxxx.sandboxxxxx.opentlc.com:6443
    exit 1
fi

# ログイン
export MASTER_URL=$1
oc login ${MASTER_URL} -u opentlc-mgr -p r3dh4t1! --insecure-skip-tls-verify=true
oc project labs-infra

for m in {1..4}; do
  echo モジュール $m を置き換えます
  export CONTENT_URL_PREFIX=https://github.com/team-ohc-jp-place/cloud-native-workshop-v2m${m}-guides/tree/ocp-4.5-jp
  export WORKSHOPS_URLS=${CONTENT_URL_PREFIX}/_cloud-native-workshop-module${m}.yml
  # 元データ確保
  oc get dc/guides-m${m} -o yaml > orignal_guilde-m${m}.yaml
  # ドキュメント参照先変更
  oc set env dc/guides-m${m} --overwrite CONTENT_URL_PREFIX=${CONTENT_URL_PREFIX} WORKSHOPS_URLS=${WORKSHOPS_URLS}
done
