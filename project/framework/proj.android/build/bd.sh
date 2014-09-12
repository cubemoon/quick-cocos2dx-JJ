#!/usr/bin/env bash

premessable_code=00012243
premessable_code_default=00012440
premessable_code_for_50042=00012249
premessable_code_for_50020=00012247
premessable_code_for_50008=00012299
premessable_code_for_40001=00012463
premessable_code_for_40006=00012498 
premessable_code_for_30000=00012243
premessable_code_for_50080=00012243
premessable_code_for_50583=00017506
premessable_code_for_50580=00012329
premessable_code_for_50585=00012329
premessable_code_for_50034=00012329
premessable_code_for_38427=00018085
premessable_code_for_38635=00018494
BUILDALL=no
LAUNCHER=yes
BATCHFILE=no
target_env=normal
promoterId=999999
versionId=
destDir=
OUT_BUILD=no
IN_BUILD=yes
PROJ_NAME=JJPKLord
LAZY_MODE=no
PACKAGE=cn.jj.pklord
dir_prefix=..
CP_RES=no
BAIDU=no
VER_CODE=
VER_NAME=
PACKAGE=
ACTIVITY_NAME=
APP_NAME=
RES_MODE=normal
ICON_BACK_FILE=
ENCRYPT=yes
COMPLIE_NATIVE_CODE=no
PACKAGES=
PLATFORM=android
DO_ZIP=no
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DIR="$DIR/.."
APP_ROOT="$DIR/.."
APP_ANDROID_ROOT="$DIR"
QUICK_COCOS2DX_ROOT="$APP_ROOT/../.."
COCOS2DX_ROOT="$QUICK_COCOS2DX_ROOT/lib/cocos2d-x"
XXTEA_ROOT="$QUICK_COCOS2DX_ROOT/lib/cocos2d-x/external/extra/crypto/xxtea"

if [ -d "/cygdrive/" ]; then
    ANDROID_NDK_ROOT=`cygpath "$ANDROID_NDK_ROOT"`
    QUICK_COCOS2DX_ROOT=`cygpath "$QUICK_COCOS2DX_ROOT"`
    COCOS2DX_ROOT=`cygpath "$COCOS2DX_ROOT"`
fi

echo "QUICK_COCOS2DX_ROOT=$QUICK_COCOS2DX_ROOT"
echo "COCOS2DX_ROOT=$COCOS2DX_ROOT"
usage_and_exit()
{
    cat <<EOF
Usage:
[-f] [--launcher] [-p] [--res] [--lazy]
   -f           build all in the spec file
   --launcher   if the apk show in main menu application list, [all, yes, no] default is yes
   -p           promoter id
   -t           target env, such as qihoo,kuaiya, default is normal
   --genres     gen android res to R.java
   --install 	install apk
   --sys        android or ios, default is android
   --zip        build zip package
   -n           package name, lordunion, poker, and so no
EOF

    exit 1
}
copy_configs()
{
#	find ../../module -type d -mindepth 1 -maxdepth 1 | sed 's/\..*\///g'
	packages=`find ../../module -type d -mindepth 1 -maxdepth 1 | sed 's/\..*\///g'`
	if [ ! -n "$PACKAGES" ]
		then
		echo "packages is default"
	else
		echo "PACKAGE=$PACKAGES"
		packages=$PACKAGES
	fi
	echo "packages=$packages"
	  while IFS=' ' read -ra line; do
    echo "line=$line"
    for i in "${line[@]}"; do
      if [ -d $APP_ROOT/module/$i/configures/${PLATFORM}/res ]
      then
        cp -rf $APP_ROOT/module/$i/configures/${PLATFORM}/res ../assets/module/$i
      fi

      if [ -d ../assets/module/$i/configures ]
      then
        rm -r ../assets/module/$i/configures
      fi
	  
    done
  done <<< $packages

}
compy_res()
{
	echo "DIR=$DIR"

    if [ -d $dir_prefix/assets ]
    then
		#chmod +w -R $dir_prefix/assets
		rm -r $dir_prefix/assets
    fi

	mkdir $dir_prefix/assets

	#cp thrids/share/*.*
	cp -rvf "$APP_ANDROID_ROOT"/share/. "$APP_ANDROID_ROOT"/assets/

	if [ "$1" = "yes" ]; then
		gcc "$XXTEA_ROOT"/encrypt.c "$XXTEA_ROOT"/xxtea.c -o "$APP_ROOT"/encrypt -lz
		echo "- encrypt scripts"
		$APP_ROOT/encrypt --input $APP_ROOT/scripts $APP_ROOT/module --output $APP_ROOT/tmp
		echo "- copy scripts"
		cp -rf "$APP_ROOT"/tmp/scripts "$APP_ANDROID_ROOT"/assets/
		cp -rf "$APP_ROOT"/tmp/module "$APP_ANDROID_ROOT"/assets/
		echo "- copy resources"
		cp -rf "$APP_ROOT"/res "$APP_ANDROID_ROOT"/assets/

		rm -rf "$APP_ROOT"/tmp
		rm -rf "$APP_ROOT"/encrypt
	else
		echo "Copy scripts without encrypt"
		cp -rf "$APP_ROOT"/scripts "$APP_ANDROID_ROOT"/assets/
		cp -rf "$APP_ROOT"/res "$APP_ANDROID_ROOT"/assets/
        cp -rf "$APP_ROOT"/module "$APP_ANDROID_ROOT"/assets/
		echo "APPROOT=$APP_ROOT"
		echo "APP_ADNROID_ROOT=$APP_ANDROID_ROOT"
	fi
		
	copy_configs
}
reset_envrioment()
{
    echo "--- clear the env ... ---"
}

set_common_env()
{
    echo "set common env ..."
    cp -vf $dir_prefix/build/build.xml $dir_prefix/build.xml
    cp -vf $dir_prefix/build/proguard.config $dir_prefix/proguard.config

    PROJ_NAME=`sed -n -e '1p' ../project.cfg|sed 's/apk_name=//'`
    echo "PROJ_NAME=$PROJ_NAME"
    
    VER_CODE=`sed -n -e '2p' ../project.cfg|sed 's/ver_code=//'`
    VER_NAME=`sed -n -e '3p' ../project.cfg|sed 's/ver_name=//'`

	PACKAGE=`sed -n -e '4p' ../project.cfg|sed 's/package=//'`
#	ACTIVITY_NAME=`sed -n -e '5p' ../project.cfg|sed 's/activity_name=//'`
	APP_NAME=`sed -n -e '6p' ../project.cfg|sed 's/app_name=//'`
	ACTIVITY_NAME="cn.jj.mobile.lobby.view.Main"
	SHARE_FILTER=`sed -n -e '7p' ../project.cfg|sed 's/share_filter=//'`
	APP_NAME_EN=`sed -n -e '8p' ../project.cfg|sed 's/app_name_en=//'`

    echo "VER_CODE=${VER_CODE}"
    echo "VER_NAME=${VER_NAME}"
	echo "PACKAGE=${PACKAGE}"
	echo "ACTIVITY_NAME=${ACTIVITY_NAME}"
	echo "APP_NAME=${APP_NAME}"
	echo "APP_NAME_EN=${APP_NAME_EN}"
	echo "SHARE_FILTER=${SHARE_FILTER}"
    mv $dir_prefix/build.xml $dir_prefix/tmp.xml
    sed -e "s/<project name=\"JJApp\"/<project name=\"$PROJ_NAME\"/"<$dir_prefix/tmp.xml>$dir_prefix/build.xml
	rm $dir_prefix/tmp.xml
    # deal common res
	PACKAGE_PATH=`echo $PACKAGE | sed "s/\./\//g"`
	echo "PACKAGE_PATH=$PACKAGE_PATH"
	if ! [ -d $dir_prefix/src/$PACKAGE_PATH ]
	then
		mkdir $dir_prefix/src/$PACKAGE_PATH/
	fi
	cp -rvf $dir_prefix/src/cn/sharesdk/wxapi $dir_prefix/src/$PACKAGE_PATH/

	mv $dir_prefix/src/$PACKAGE_PATH/wxapi/WXEntryActivity.java $dir_prefix/tmp.java
	sed -e "s/package cn\.sharesdk\.wxapi;/package $PACKAGE\.wxapi;/"<$dir_prefix/tmp.java>$dir_prefix/src/$PACKAGE_PATH/wxapi/WXEntryActivity.java
	rm $dir_prefix/tmp.java

#config default app name
	mv -vf $dir_prefix/res/values/strings.xml ./temp.xml
	sed -e "s/<string name=\"app_name\">.*<\/string>/<string name=\"app_name\">${APP_NAME}<\/string>/"<temp.xml>$dir_prefix/res/values/strings.xml
	rm temp.xml
#config English app name
	mv -vf $dir_prefix/res/values-en/strings.xml ./temp.xml
	sed -e "s/<string name=\"app_name\">.*<\/string>/<string name=\"app_name\">${APP_NAME_EN}<\/string>/"<temp.xml>$dir_prefix/res/values-en/strings.xml
	rm temp.xml
    echo "set common env success."
}
set_normal_env()
{
    echo "--- set normal env ---"
    set_common_env
}

set_kuaiya_env()
{
	set_common_env
	cp -vf $dir_prefix/build/env/kuaiya/AndroidManifest_kuaiya.xml $dir_prefix/build/AndroidManifest.xml
	cp -vf $dir_prefix/build/env/kuaiya/common_jj_logo.png $dir_prefix/res/drawable/icon.png
	cp -vf $dir_prefix/build/env/kuaiya/kuaiya_logo.png $APP_ROOT/module/upgrade/res/img/upgrade/kuaiya_logo.png
	cp -vf $dir_prefix/build/env/kuaiya/strings.xml $dir_prefix/res/values/strings.xml
}

set_egame_env()
{
	set_common_env
	cp -vf $dir_prefix/build/env/egame/AndroidManifest_egame.xml $dir_prefix/build/AndroidManifest.xml
	
	#libs
	cp -vf `find '../build/env/egame/libs/armeabi' -name \*.so` $dir_prefix/libs/armeabi/
	cp -vf `find '../build/env/egame/libs' -name \*.jar` $dir_prefix/libs/
	
	#res
	cp -vf `find '../build/env/egame/res/drawable/' -name \*.xml` $dir_prefix/res/drawable/
	cp -vf `find '../build/env/egame/res/drawable-hdpi' -name \*.png -o -name *.jpg` $dir_prefix/res/drawable-hdpi/
	cp -vf `find '../build/env/egame/res/layout/' -name \*.xml` $dir_prefix/res/layout/
	cp -vf `find '../build/env/egame/res/values/' -name \*.xml` $dir_prefix/res/values/
	
	#assets
	cp -vf `find '../build/env/egame/assets/' -name \*.apk -o -name \*.dat` $dir_prefix/assets/

	#src
	cp -vf `find '../build/env/egame/src' -name \*.java` $dir_prefix/src/cn/jj/base/
}

set_envrioment()
{
    echo "set the env : $1"
    if [ "$1" = "normal" ]
    then 
		echo "set normal env ..."
		set_normal_env
	elif [ "$1" = "kuaiya" ]
	then
		set_kuaiya_env
	elif [ "$1" = "egame" ]
	then
		set_egame_env
    else
		echo "ERROR: unknown env $1"
		exit 1
    fi
 
    if [ $LAZY_MODE = "yes" ]
    then
		cp -vf $dir_prefix/build.properties  $dir_prefix/build_tmp.properties
		sed -e "s/proguard.enabled=true//" -e "s/proguard.config=proguard.config//"<$dir_prefix/build_tmp.properties>$dir_prefix/build.properties
    fi

    echo "OK env set success."
}

config_version()
{

    echo "---------config version ......"
    oldFile=$dir_prefix/AndroidManifest.xml
    backFile=$dir_prefix/temp.xml
    backFile2=$dir_prefix/tmp2.xml
    verCode=android:versionCode
    verName=android:versionName
    
    echo "the parameters are : $1, $2, $3"
	cp -f AndroidManifest.xml $oldFile

    mv -vf $oldFile $backFile
#-e "s/android:label=\".*\"/android:label=\"${APP_NAME}\"/"
    sed -e "s/android:name=\"cn.jj.wxapi.WXEntryActivity\"/android:name=\"${PACKAGE}.wxapi.WXEntryActivity\"/" -e "s/android:scheme=\"tencent101028429\"/android:scheme=\"${SHARE_FILTER}\"/" -e "s/android:name=\"provider.authorities\" android:value=\".*\"/android:name=\"provider.authorities\" android:value=\"${PACKAGE}""${ACTIVITY_NAME}".content"\"/" -e "s/android:authorities=\".*\"/android:authorities=\"${PACKAGE}""${ACTIVITY_NAME}".content"\"/" -e "3s/package=\".*\"/package=\"${PACKAGE}\"/" -e "s/${verCode}=\"[0-9]\{5,10\}\"/${verCode}=\"$1\"/" -e "s/${verName}=\"[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\"/${verName}=\"$2\"/"<$backFile>$oldFile

	#处理是否带应用图标
    if [ "$3" = "no" ]
    then
		mv -vf $oldFile $backFile2
		echo "ok remove the launcher tag"
		sed '/\<category android\:name=\"android.intent.category.LAUNCHER\" \/>/d'<$backFile2>$oldFile
		rm -f $backFile2
    else
		echo "do nothing"
    fi
    
    rm -f $backFile

    echo "------------config version ok.----------------"
}

set_icon_invisible()
{
    echo "---------set_icon_invisible ......"
    oldFile=$dir_prefix/AndroidManifest.xml
    ICON_BACK_FILE=$dir_prefix/icon_temp.xml
    backFile2=$dir_prefix/tmp2.xml
    
    echo "backup AndroidManifest.xml"
    cp -vf $oldFile $ICON_BACK_FILE

	mv -vf $oldFile $backFile2
	echo "ok remove the launcher tag"
	sed '/\<category android\:name=\"android.intent.category.LAUNCHER\" \/>/d'<$backFile2>$oldFile
	rm -f $backFile2
    
    echo "------------set_icon_invisible ok.----------------"
}
set_icon_visible(){
	echo "---------set_icon_visible ......"
    oldFile=$dir_prefix/AndroidManifest.xml    
    echo "mv AndroidManifest.xml"
    mv -vf $ICON_BACK_FILE $oldFile
	rm -vf $ICON_BACK_FILE  
    echo "------------set_icon_visible ok.----------------"	
}
build_package()
{
	#gen md5 code
	java -jar MD5.jar --so  $dir_prefix/obj/local/armeabi/libgame.so $dir_prefix/assets/so.json
    ant -f $dir_prefix/build.xml
    echo "-------build_package over--------LAUNCHER: $LAUNCHER-------------------------"
}


build_native()
{
	cd ..
	"${ANDROID_NDK_ROOT}"/ndk-build ${ANDROID_NDK_BUILD_FLAGS} -C "${APP_ANDROID_ROOT}" $* \
		"NDK_MODULE_PATH=${QUICK_COCOS2DX_ROOT}:${COCOS2DX_ROOT}:${COCOS2DX_ROOT}/cocos2dx/platform/third_party/android/prebuilt"

		cd build
}
build_target()
{
    echo "------------build target..."
    echo "paraments list: $1, $2, $3, $4, $5, $6, $7, $8, $9, ${10} ${11}, ${12}, ${13}, ${14}, ${15}"

    shunxu=$1
    enviroment=$2
    proId=$3
 
    echo "shunxu=$shunxu"
    echo "enviroment=$enviroment"
    echo "proId=$proId"

    reset_envrioment
    echo "=======$1"
    set_envrioment $enviroment $proId
    
    echo "PROMOTER_ID = $proId">$dir_prefix/assets/module/promoter.lua
    promoterId=${proId}
    
    echo "-----------premessable start--------------------"
    echo "premessable id: $promoterId"
    
	if [ $promoterId = "50042" ]
	then
		premessable_code=$premessable_code_for_50042	
		
	elif [ $promoterId = "50020"  ]
	then
		premessable_code=$premessable_code_for_50020	
		
	elif [ $promoterId = "50008"  ]
	then
		premessable_code=$premessable_code_for_50008
	elif [ $promoterId = "40001"  ]
	then
		premessable_code=$premessable_code_for_40001
	elif [ $promoterId = "40006"  ]
	then
		premessable_code=$premessable_code_for_40006
	elif [ $promoterId = "30000"  ]
	then
		premessable_code=$premessable_code_for_30000
	elif [ $promoterId = "50080"  ]
	then
		premessable_code=$premessable_code_for_50080
	elif [ $promoterId = "50583" ]
	then
		premessable_code=$premessable_code_for_50583
	elif [ $promoterId = "50580" ]
	then
		premessable_code=$premessable_code_for_50580
	elif [ $promoterId = "50585" ]
	then
		premessable_code=$premessable_code_for_50585
	elif [ $promoterId = "50034" ]
	then
		premessable_code=$premessable_code_for_50034
	elif [ $promoterId = "38427" ]
	then
		premessable_code=$premessable_code_for_38427
	elif [ $promoterId = "38635" ]
	then
		premessable_code=$premessable_code_for_38635
	else
	    premessable_code=$premessable_code_default
	fi
	echo "premessable_code=${premessable_code}"
	echo $premessable_code>$dir_prefix/assets/premessable.txt
	echo "-----------premessable end--------------------"
    
    buildtime=`date '+%Y-%m-%d %H:%M:%S'`
    echo "compile date time: $buildtime"
    echo "BUILD_TIME = \"$buildtime\"">$dir_prefix/assets/compiletime.lua

    launcher=yes

    #configure LAUNCHER flag
    echo "LAUNCHER=$LAUNCHER"

    if [ $LAUNCHER = "yes" ]
    then
		launcher="yes"
		apk_icon="visible"
	elif [ $LAUNCHER = "all" ]
	then
		launcher="yes"
		apk_icon="visible"
    else
		launcher="no"
		apk_icon="invisible"
    fi
    echo "config_version before ,LAUNCHER=$LAUNCHER"
    config_version "$VER_CODE" "$VER_NAME" "$launcher"

 	echo "config_version over ,LAUNCHER=$LAUNCHER"
    
    outsideDir="dest/${shunxu}"
    
    if [ ! -d dest ]
    then
		mkdir dest
    fi

    if test ! -d $outsideDir
    then
		echo "the dir: $outsideDir is not exist"
		mkdir $outsideDir
		chmod +w -R $outsideDir
    fi

    if [ ! $LAZY_MODE = "yes" ]
    then
		build_package 
		cp -vf $dir_prefix/bin/${PROJ_NAME}-release.apk dest/${shunxu}/${PROJ_NAME}$res_mode.$VER_CODE.$proId.$apk_icon.apk
    else
		build_package 
		echo "adb install -r XXX.apk"
		adb install -r $dir_prefix/bin/${PROJ_NAME}-release.apk
#		PACKAGE=`sed -n -e '3p' ../AndroidManifest.xml|sed 's/package=\"//'|sed 's/\"//'`
		echo "pk name: $PACKAGE"
		adb shell am start -n $PACKAGE/$ACTIVITY_NAME
	#adb shell am start -n cn.jj.pklord/cn.jj.mobile.lobby.view.Main

    fi

    if [ $LAUNCHER = "no" ]
    then
		LAUNCHER=yes
    fi

    echo "--------------------build sucess ! promoter id =$3---------------------"
}

while [ $# -gt 0 ]
do 
    case $1 in
		help)
			usage_and_exit
			shift
			;;
		-f)BUILDALL=yes
			BATCHFILE=$2
			shift
			;;
		--launcher)LAUNCHER=$2
			shift
			;;
		-p) promoterId=$2
			shift
			;;
		-t) target_env=$2
			shift
			;;
		--lazy) LAZY_MODE=yes
			CP_RES=yes
			;;
		--res) CP_RES=yes
			shift
			;;
		-e)ENCRYPT=$2
			shift
			;;
		--install)
			set_common_env
			adb install -r ../bin/$PROJ_NAME-release.apk
			shift
			exit 0
			;;
		--uninstall)
			set_common_env
			cd ..
			ant uninstall
			cd build
			shift
			exit 0
			;;
		--genres)
			set_common_env
			ant -f $dir_prefix/build.xml gen-res
			shift
			exit 0
			;;
		--update)
			cd ../../
			svn up
			cd ./proj.android/build
			shift
			exit 0
			;;
		--native)
			build_native
			shift
			exit 0
			;;
		--start)
			set_common_env
			adb shell am start -n $PACKAGE/$ACTIVITY_NAME
			shift
			exit 0
			;;
		--stop)
			set_common_env
			adb shell am force-stop $PACKAGE
			shift
			exit 0
			;;
		--cpres)
			compy_res $ENCRYPT
		#	copy_configs
			shift
			exit 0
			;;
		--sys)
			PLATFORM=$2
			echo "PLATFORM=$PLATFORM"
			shift
			;;
		-n)
			if [ ! $PACKAGES ]
				then
				PACKAGES=$2
				echo "$PACKAGES"
				echo "11"
			else
				PACKAGES=${PACKAGES}" "$2
				echo "$PACKAGES"
				echo "22"
			fi
			shift
			;;
		--zip)
			DO_ZIP=yes
			shift
			;;
        *) usage_and_exit
    esac
    shift
done
do_zip_func()
{
	echo "need to do..."
}
if [ $DO_ZIP = "yes" ]
then
	do_zip_func
	exit 0
fi

if [ -d ../bin ]
then
    rm -r ../bin
fi

echo "promoterId=${promoterId}"

#echo "destDir=${destDir}"

#if [ ! -d $dir_prefix/dest  ]; then
#    echo "dest dir not exist, create it..."
#    mkdir $dir_prefix/dest
#    chmod +w -R $dir_prefix/dest
#fi

#编译native code
build_native
compy_res $ENCRYPT

if [ $BUILDALL = "yes" ]
then
    if [ -n "$BATCHFILE" ]
    then
		echo "be to read file"
		while read  line
		do
			echo $line
			
			cnt=0
			sx=
			pid=

			for var in $line
			do
				if [ $cnt = 0 ]
				then
					sx=$var
				elif [ $cnt = 1 ]
				then
					pid=$var
				fi
				cnt=$((cnt + 1))				
	#	echo "$var"
			done
			
			cnt=0
			echo "-----===: $sx, $ev, $pid"
			build_target $sx $target_env $pid 
	   #exit 1
			echo "build ok............................................"
			done<$BATCHFILE
    else
		usage_and_exit
    fi
else
	echo "target_env=$target_env"
    build_target "default" $target_env $promoterId 
fi
