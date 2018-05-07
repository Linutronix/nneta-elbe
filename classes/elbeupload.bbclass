

python () {
    d.appendVarFlag('do_upload_debs', 'depends', " %s:do_build" % d.getVar('ELBE_PBUILDER_PROJECT', True))
    deps = d.getVar('PACKAGE_BUILD', True)
    if not deps:
        deps = ""
    for dep in deps.split():
        d.appendVarFlag('do_upload_debs', 'depends', " %s:do_build" % dep)
}

do_upload_debs () {
    EPROJECT=`cat ${WORKDIR}/../../../${BUILD_SYS}/${ELBE_PBUILDER_PROJECT}/1.0-r0/eproject`
    for arch in ${PACKAGE_ARCHS}; do
        if [ -d ${DEPLOY_DIR_DEB}/$arch ] ; then
            for deb in ${DEPLOY_DIR_DEB}/$arch/*.deb; do
                ${ELBE_BIN} prjrepo upload_pkg $EPROJECT "$deb"
            done
        fi
    done
}

addtask upload_debs before do_build
