ipaShellPath="/Volumes/Data/SherwinGitPro/iOS_Make_ipa"

ProjectPath=$(cd "$(dirname "$0")"; pwd)

echo  $ShellPath
#mmt_ipa.sh 1 prject   
cd  ${ipaShellPath}

exec ./mmt_ipa.sh 1 ${ProjectPath}
