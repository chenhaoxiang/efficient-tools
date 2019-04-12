# 读取ini配置文件
function ReadINIfile()    
{   
	# key名称 
    Key=$1  
    # []模块 
    Section=$2  
    # 文件路径  
    Configfile=$3  
    ReadINI=`awk -F '=' '/\['$Section'\]/{a=1}a==1&&$1~/'$Key'/{print $2;exit}' $Configfile`    
    echo "$ReadINI"    
}

