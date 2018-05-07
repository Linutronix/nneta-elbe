
inherit elbebase

export ELBE_USER
export ELBE_PASS

python do_configure() {
    write_mako_template(d, "elbeproject.xml")
}

do_compile() {
    cd ${WORKDIR}
    ${ELBE_BIN} control create_project > eproject
    EPROJECT=`cat eproject`
    ${ELBE_BIN} control set_xml $EPROJECT elbeproject.xml
    ${ELBE_BIN} pbuilder create --project $EPROJECT
}

addtask compile before do_build

do_compile[depends] += "initvm:do_build"

do_fetch[noexec] = "1"
do_unpack[noexec] = "1"
do_patch[noexec] = "1"
do_install[noexec] = "1"
do_populate_sysroot[noexec] = "1"
do_package[noexec] = "1"
do_package_qa[noexec] = "1"
do_packagedata[noexec] = "1"
do_package_write_ipk[noexec] = "1"
do_package_write_deb[noexec] = "1"
do_package_write_rpm[noexec] = "1"
