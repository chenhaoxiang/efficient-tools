#!/usr/bin/env bash
#!/bin/bash

# 读取读取文件的函数
source ./read.sh
# 引入git的操作函数 
source ./git.sh

# ini配置文件
configFile="./config.ini"

itemCount=`ReadINIfile "project-count" "General" "$configFile"`
echo "配置的项目数目:"$itemCount
 
asArr=()
nameArr=()
sshArr=()
httpArr=()
commitpArr=()
relyArr=()
localpathArr=()
modelArr=()
runModelArr=()
installModelArr=()
branchArr=()
profilesActiveArr=()
echo "读取的配置：" 
for((i=0; i<itemCount; i++))
do
	Section="project"$i  
    echo $Section   
	asArr[$i]=`ReadINIfile "as" "$Section" "$configFile"`
	nameArr[$i]=`ReadINIfile "name" "$Section" "$configFile"`
	sshArr[$i]=`ReadINIfile "ssh-address" "$Section" "$configFile"`
	httpArr[$i]=`ReadINIfile "http-address" "$Section" "$configFile"`
	commitpArr[$i]=`ReadINIfile "commit" "$Section" "$configFile"`
	relyArr[$i]=`ReadINIfile "rely" "$Section" "$configFile"`
	localpathArr[$i]=`ReadINIfile "localpath" "$Section" "$configFile"`
	modelArr[$i]=`ReadINIfile "model" "$Section" "$configFile"`
	runModelArr[$i]=`ReadINIfile "run-model" "$Section" "$configFile"`
	installModelArr[$i]=`ReadINIfile "insatall-model" "$Section" "$configFile"`
	branchArr[$i]=`ReadINIfile "branch" "$Section" "$configFile"`
	profilesActiveArr[$i]=`ReadINIfile "profiles-active" "$Section" "$configFile"`
	echo "项目别名:"${asArr[$i]}
	echo "项目全名:"${nameArr[$i]}
	echo "项目SSH连接地址:"${sshArr[$i]}
	echo "项目Http连接地址:"${httpArr[$i]}
	echo "项目描述:"${commitpArr[$i]}
	echo "项目上级依赖序号:"${relyArr[$i]}
	echo "项目本地路径:"${localpathArr[$i]}
	echo "项目分支:"${branchArr[$i]}
	echo "项目模块:"${modelArr[$i]}
	echo "项目运行模块:"${runModelArr[$i]}
	echo "项目install模块:"${installModelArr[$i]}
	echo "项目运行环境:"${profilesActiveArr[$i]}
	echo "=================================="  
done

# 运行项目
function runProject()    
{     
	# 依赖的项目标号
    local num=$1    
	# 运行项目 
	echo "开始运行项目:""$num""${nameArr[$num]}" 
	# 获取install模块
	local runModel=${runModelArr[$num]}
	echo "运行模块配置:""$runModel"
	# 进入项目路径 
	local path=${localpathArr[$num]}${nameArr[$num]}
	if [[ $runModel != "0" ]]; then 
		path=$path"/"$runModel 
		echo "项目路径:""$path"

		# kill jar 
		PID=$(ps -ef | grep $runModel | grep -v grep | awk '{ print $2 }')
		if [ -z "$PID" ]
		then
		    echo Application is already stopped
		else
		    echo kill $PID
		    kill $PID
		fi
		path=$path/target
		echo "项目target路径:""$path"
		# 获取target路径下的jar包路径
		local jarName=`getPathLastJar "$path"`
		local profilesActive=${profilesActiveArr[$num]} 
		echo "jarName:""$jarName"
		echo "profilesActive:""$profilesActive"
		nohup java -server -jar $path/${jarName} --spring.profiles.active=${profilesActive} > nohup-${runModel}.log &
		echo "${nameArr[$num]}""运行成功"   
	fi
	echo "===================================="   
	echo "===================================="   
	echo "===================================="   
	return 0 
}

echo "请选择:
1.拉取项目（开发中）
2.编译项目（开发中）
3.运行项目
0.退出"

read -p "输入选择 [0-3] >" num
if [[ $num =~ ^-?[0-9]+$ ]]; then
echo "选择的是:$num."
	if [[ $num == 0 ]]; then
		echo "程序退出"
		exit;
	fi

	if [[ $num == 3 ]]; then
		echo "请输入需要运行项目的序号:"
		for((i=0; i<itemCount; i++))
		do 
			echo "$i"".""${asArr[$i]}"" ${nameArr[$i]}" 
		done

		read -p "输入序号 [0-$itemCount) >" runNum
		if [[ $runNum < 0 ]]; then
			exit;
		fi
		if [[ $runNum > $itemCount-1 ]]; then
			exit;
		fi
  
		echo "运行项目：""$runNum"".""${asArr[$runNum]}"" ${nameArr[$runNum]}" 
		retu=`installProject "$runNum"`   
		echo "$retu" 
		# 显示项目log
		runModel=${runModelArr[$runNum]}
		tail -f nohup-${runModel}.log
	fi


else
echo "请输入数字.程序退出."
exit;
fi
