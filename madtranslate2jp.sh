#!/bin/bash                                                                                                                                                   

# 引数チェック
if [ $# != 2 ]; then
    echo "引数が間違っています" $*
    exit 1
fi
if [ $1 = "" ]; then
    echo "引数にMASTERのURLを指定して下さい"
    echo 例 \: $0 https://api.cluster-xxxx.sandboxxxx.opentlc.com:6443
    exit 1
fi
if [ $2 = "" ]; then
    echo "引数にユーザのパスワードを指定してください"
    exit 1
fi

# ログイン
export MASTER_URL=$1
oc login ${MASTER_URL} -u admin -p $2 --insecure-skip-tls-verify=true

if [ `oc whoami` ]; then
  
  #ガイドプロジェクトを指定
  oc project dev-guides
  
  #モジュールを日本語に置き換えます 
  for m in {1..5}; do
        echo モジュール $m を置き換えます
        #export CONTENT_URL_PREFIX=https://raw.githubusercontent.com/team-ohc-jp-place/cloud-native-workshop-v2m${m}-guides/ocp-4.9-jp
        #export CONTENT_URL_PREFIX=https://raw.githubusercontent.com/nmushino/mad-dev-guides-m${m}-guides/202306-jp
        #export WORKSHOPS_URLS=${CONTENT_URL_PREFIX}/_cloud-native-workshop-module${m}.yml
        
        #oc get dc/guides-m${m} -o yaml > orignal_guilde-m${m}.yaml
        #oc set env dc/guides-m${m} --overwrite CONTENT_URL_PREFIX=${CONTENT_URL_PREFIX} WORKSHOPS_URLS=${WORKSHOPS_URLS}

        #英語コンテンツの削除
        oc delete deployment mad-dev-guides-m${m}
        oc delete bc/mad-dev-guides-m${m}
        oc delete svc mad-dev-guides-m${m}
        oc delete route mad-dev-guides-m${m}

        #日本語コンテンツの追加
        oc new-app https://github.com/team-ohc-jp-place/mad-dev-guides-m${m}.git#main-jp --strategy=docker
        oc create route edge mad-dev-guides-m${m} --service=mad-dev-guides-m${m}
   done
 
fi
