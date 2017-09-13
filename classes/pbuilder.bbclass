do_build () {
    cd ${WORKDIR}/../../elbeproject/1.0-r0
    EPROJECT=`cat eproject`
    cd ${S}
    elbe pbuilder build --project=$EPROJECT
    elbe control wait_busy $EPROJECT
    cd ${WORKDIR}
    FILES=`elbe prjrepo download $EPROJECT`
    mkdir -p ${DEPLOY_DIR_DEB}
    for f in $FILES; do
        if [ -f $f ]; then tar xvf $f --strip-components=1 -C ${DEPLOY_DIR_DEB}; fi
    done
}

addtask build after do_unpack
do_build[depends] += "elbeproject:do_createpbuilder"

do_populate_sysroot() {
    echo 'nothing to do'
}
addtask populate_sysroot after do_build
do_populate_sysroot[depends] = "${PN}:do_build"
