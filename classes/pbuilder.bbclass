
inherit elbebase

export ELBE_USER
export ELBE_PASS

python () {
    d.appendVarFlag('do_compile', 'depends', " %s:do_build" % d.getVar('ELBE_PBUILDER_PROJECT', True))
}

do_compile () {
    cd ${S}
    EPROJECT=`cat ${WORKDIR}/../../../${BUILD_SYS}/${ELBE_PBUILDER_PROJECT}/1.0-r0/eproject`
    ${ELBE_BIN} pbuilder build --project=$EPROJECT
    ${ELBE_BIN} control wait_busy $EPROJECT
    cd ${WORKDIR}
    FILES=`${ELBE_BIN} prjrepo download $EPROJECT`
    mkdir -p ${DEPLOY_DIR_DEB}
    for f in $FILES; do
        if [ -f $f ]; then tar xvf $f --strip-components=1 -C ${DEPLOY_DIR_DEB}; fi
    done
}

addtask compile before do_build after do_patch

do_configure[noexec] = "1"
do_install[noexec] = "1"
do_populate_sysroot[noexec] = "1"
do_package[noexec] = "1"
do_package_qa[noexec] = "1"
do_packagedata[noexec] = "1"
do_package_write_ipk[noexec] = "1"
do_package_write_deb[noexec] = "1"
do_package_write_rpm[noexec] = "1"
do_populate_lic[noexec] = "1"
