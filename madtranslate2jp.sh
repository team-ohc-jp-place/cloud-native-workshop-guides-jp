#!/bin/bash                                                                                                                                   

# 引数チェック
if [ $# != 2 ]; then
    echo "引数にMASTERのURLとCluster Adminのパスワードを指定して下さい" $*
    echo 例 \: $0 https://api.cluster-xxxx.sandboxxxx.opentlc.com:6443 XXXXXX
    exit 1
fi

# ログイン
export MASTER_URL=$1
oc login ${MASTER_URL} -u admin -p $2 --insecure-skip-tls-verify=true

# ブランチのバージョン
export CONTENT_PREFIX=ocp-4.15-jp

if [ `oc whoami` ]; then

  #ガイドプロジェクトを指定
  oc project dev-guides
  
  #モジュールを日本語に置き換えます 
  for m in {1..7}; do
        echo モジュール $m を置き換えます
        
        #英語コンテンツの削除
        oc delete deployment mad-dev-guides-m${m}
        oc delete bc/mad-dev-guides-m${m}
        oc delete svc mad-dev-guides-m${m}
        oc delete route mad-dev-guides-m${m}

        #日本語コンテンツの追加
        oc new-app https://github.com/team-ohc-jp-place/mad-dev-guides-m${m}.git#${CONTENT_PREFIX} --strategy=docker
        oc create route edge mad-dev-guides-m${m} --service=mad-dev-guides-m${m}
   done
   
fi
