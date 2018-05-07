
inherit elbebase

IMAGE_INSTALL ?= ""
IMAGE_INSTALL[type] = "list"

DEPENDS += "${PACKAGE_BUILD}"

# Images are generally built explicitly, do not need to be part of world.
EXCLUDE_FROM_WORLD = "1"


python do_setup () {
    write_mako_template(d, "source.xml")
}

addtask setup before do_build

do_rootfs () {
    EPROJECT=`cat ${WORKDIR}/../../${ELBE_PBUILDER_PROJECT}/1.0-r0/eproject`
    ${ELBE_BIN} control set_xml $EPROJECT ${WORKDIR}/source.xml
    ${ELBE_BIN} control build $EPROJECT
    ${ELBE_BIN} control wait_busy $EPROJECT
    mkdir -p ${DEPLOY_DIR_IMAGE}
    ${ELBE_BIN} control get_files --output=${DEPLOY_DIR_IMAGE} $EPROJECT
}

addtask rootfs before do_build after do_setup

python () {
    d.appendVarFlag('do_rootfs', 'depends', d.getVar('ELBE_PBUILDER_PROJECT', True) )
}
