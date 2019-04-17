
inherit elbebase
inherit native

ELBE_INITVM_PRIMARY_HOST ?= "${ELBE_PRIMARY_HOST}"
ELBE_INITVM_PRIMARY_PATH ?= "${ELBE_PRIMARY_PATH}"
ELBE_INITVM_SIZE ?= "80G"
ELBE_INITVM_MEM ?= "16G"
ELBE_INITVM_SWAP_SIZE ?= "10GiB"

ELBE_INITVM_URLLIST ?= "http://security.debian.org/debian-security,stretch/updates,main \
			http://debian.linutronix.de/elbe,stretch,main,http://debian.linutronix.de/elbe/elbe-repo.pub \
			http://debian.linutronix.de/elbe-common,stretch,main,http://debian.linutronix.de/elbe-common/elbe-repo.pub \
			http://ftp.de.debian.org/debian,stretch-backports,main"

python do_configure() {
    write_mako_template(d, "initvm.xml")
}

addtask configure before do_build

do_initvm_start() {
    if [ -d ${ELBE_BIN_WORKDIR} ]; then
        cd ${ELBE_BIN_WORKDIR}
    fi
    ${ELBE_BIN} initvm start
}

do_initvm_create() {
    if [ -d ${ELBE_BIN_WORKDIR} ]; then 
        cd ${ELBE_BIN_WORKDIR}
    fi
    ${ELBE_BIN} initvm create --directory ${ELBE_INITVM}/initvm ${ELBE_INITVM_EXTRA_OPTS} ${WORKDIR}/initvm.xml
    touch ${ELBE_INITVM}/stamp
}

python do_compile() {
    initvm_dir = d.getVar("ELBE_INITVM", True)
    initvm_lockfile  = os.path.join(initvm_dir, "lockfile")
    initvm_stampfile = os.path.join(initvm_dir, "stamp")

    try:
        os.makedirs(initvm_dir)
    except FileExistsError:
        # its ok, when the directory already exists
        pass

    lf = bb.utils.lockfile(initvm_lockfile)

    if not os.path.exists(initvm_stampfile):
        bb.build.exec_func("do_initvm_create", d)
    else:
        bb.build.exec_func("do_initvm_start", d)


    bb.utils.unlockfile(lf)
}

addtask compile before do_build after do_configure

do_add_user () {
    ${ELBE_BIN} control add_user "${ELBE_USER}" "${ELBE_FULLNAME}" "${ELBE_PASS}" "${ELBE_EMAIL}"
}

addtask add_user before do_build after do_compile
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
