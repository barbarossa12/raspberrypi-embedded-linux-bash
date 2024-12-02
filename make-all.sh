# script to build all the raspberry pi images using buildroot
read -p "Enter buildroot directory:" BUILDROOT_DIRECTORY
read -p "Enter output directory:" IMAGE_OUTPUT_DIRECTORY
CONFIGS_LIST=$(ls ./${BUILDROOT_DIRECTORY}/configs/ | grep rasp)
cd ${BUILDROOT_DIRECTORY}


for CONFIG in $CONFIGS_LIST;
    do
        if [ ! -d "${IMAGE_OUTPUT_DIRECTORY}" ]; then
                mkdir "${IMAGE_OUTPUT_DIRECTORY}"
        fi

        mkdir -p ${IMAGE_OUTPUT_DIRECTORY}/${CONFIG}
        make ${CONFIG}
        echo "MAKE: building ${CONFIG}"
        make 2>&1 | tee ${CONFIG}-build-log.log

        echo "LOG: moving build image ${CONFIG} and log to output"
        mv "./output/images/sdcard.img" "${IMAGE_OUTPUT_DIRECTORY}/${CONFIG}/${CONFIG}-sdcard.img"
        mv "${CONFIG}-build-log.log" "${IMAGE_OUTPUT_DIRECTORY}/${CONFIG}/${CONFIG}-build-log.log"


        echo "LOG: archiving build image ${CONFIG} and log"
        cd ${IMAGE_OUTPUT_DIRECTORY}
        zip -r "${CONFIG}.zip" ${CONFIG}
        cd -

        echo "LOG: cleaning up"
        make clean && make distclean
    done

