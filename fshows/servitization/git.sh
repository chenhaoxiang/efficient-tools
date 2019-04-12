
# 拉取项目
function pullProject()    
{    
	# 取值
    Key=$1  
    Section=$2  
    Configfile=$3   
    # 返回值  
    echo ""    
}

# 编译项目
function installProject()    
{ 
	# 取值
	# 依赖的项目标号
    local num=$1   
	local relyNum=${relyArr[$num]}  
    if [ $relyNum -ge 0 ]; then
		# 存在依赖，先编译依赖 
			# 遍历依赖
		retu=`installProject "$relyNum"` 
		echo "$retu"    
	fi
	# 编译
	echo "开始编译项目:""$num""${nameArr[$num]}" 
	# 获取install模块
	local installModel=${installModelArr[$num]}
	echo "编译模块配置:""$installModel"
	# 进入项目路径 
	local path=${localpathArr[$num]}${nameArr[$num]}
	if [[ $installModel != "0" ]]; then 
		path=$path"/"$installModel 
	fi
	echo "项目路径:""$path"
	mvn clean install -Dmaven.test.skip=true -f $path 
	echo "${nameArr[$num]}""编译成功"   

	runRetu=`runProject "$num"` 
	echo $runRetu
	echo "===================================="   
	echo "===================================="   
	echo "===================================="   
	return 0
}

# 获取目录下最后一个jar的文件
function getPathLastJar(){
	local path=$1
	# 获取target路径下的jar包路径
	local files=$(ls $path)
	local jarName 
	for filename in $files
	do
	   if [[ $filename =~ \.jar$ ]];then     
	   		jarName=$filename
		fi
	done
	echo $jarName
}
