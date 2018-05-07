
inherit elbebase
inherit elbeupload

IMAGE_INSTALL ?= ""
IMAGE_INSTALL[type] = "list"

# Images are generally built explicitly, do not need to be part of world.
EXCLUDE_FROM_WORLD = "1"

# poky base.bbclass normally pulls in:
# "virtual/arm-oe-linux-gnueabi-gcc virtual/arm-oe-linux-gnueabi-compilerlibs virtual/libc"
#
# we dont need these for elbe pbuilder builds.

INHIBIT_DEFAULT_DEPS = "1"

# PACKAGES comes from poky/conf/bitbake.conf
# we dont want any packages here.
PACKAGES = ""

export ELBE_USER
export ELBE_PASS

python do_setup () {
    write_mako_template(d, "elbeproject.xml")
}

addtask setup before do_build

do_rootfs () {
    EPROJECT=`cat ${WORKDIR}/../../../${BUILD_SYS}/${ELBE_PBUILDER_PROJECT}/1.0-r0/eproject`
    ${ELBE_BIN} control set_xml $EPROJECT ${WORKDIR}/elbeproject.xml
    ${ELBE_BIN} control build $EPROJECT
    ${ELBE_BIN} control wait_busy $EPROJECT
    mkdir -p ${DEPLOY_DIR_IMAGE}
    ${ELBE_BIN} control get_files --output=${DEPLOY_DIR_IMAGE} $EPROJECT
}

addtask rootfs before do_build after do_upload_debs

