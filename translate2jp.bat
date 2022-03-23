@echo off
@setlocal
@setlocal enabledelayedexpansion


if not "%2"=="" (
    goto ERROR
)

if "%1"=="" (
    goto ERROR
)

rem ���O�C��
set MASTER_URL=%1
oc login %MASTER_URL% -u opentlc-mgr -p r3dh4t1^^! --insecure-skip-tls-verify=true
oc project labs-infra

for /L %%m IN (1,1,4) DO (
  echo ���W���[�� %%m ��u�������܂�
  set CONTENT_URL_PREFIX=https://raw.githubusercontent.com/team-ohc-jp-place/cloud-native-workshop-v2m%%m-guides/ocp-4.9-jp
  set WORKSHOPS_URLS=!CONTENT_URL_PREFIX!/_cloud-native-workshop-module%%m.yml
  rem ���f�[�^�m��
  oc get dc/guides-m%%m -o yaml > orignal_guilde-m%%m.yaml
  rem �h�L�������g�Q�Ɛ�ύX
  oc set env dc/guides-m%%m --overwrite CONTENT_URL_PREFIX=!CONTENT_URL_PREFIX! WORKSHOPS_URLS=!WORKSHOPS_URLS!
)

exit /B 0

:ERROR
echo ������MASTER��URL�������w�肵�ĉ�����
echo �� ^> %0 https://api.cluster-xxxx.xxxx.sandboxxxxx.opentlc.com:6443
exit /B 1
