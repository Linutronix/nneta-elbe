
inherit elbebase
inherit elbeupload

export ELBE_USER
export ELBE_PASS

# poky base.bbclass normally pulls in:
# "virtual/arm-oe-linux-gnueabi-gcc virtual/arm-oe-linux-gnueabi-compilerlibs virtual/libc"
#
# we dont need these for elbe pbuilder builds.

INHIBIT_DEFAULT_DEPS = "1"

do_compile () {
    cd ${S}
    # source format git requires, that the git repo
    # does not reference any externals
    if grep -q git debian/source/format; then
        git repack -a
    fi
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

addtask compile before do_build after do_upload_debs do_patch

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
