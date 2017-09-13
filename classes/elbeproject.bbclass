python do_createxml() {
    from elbepack.config import cfg
    from elbepack.soapclient import ElbeSoapClient, ClientAction
    from elbepack.templates import write_template

    r = { "pkgs": "",
          "arch": d.getVar("PACKAGE_ARCH", True),
          "distro": d.getVar("DISTRO", True),
          "machine": d.getVar("MACHINE", True),
          "serial": d.getVar("SERIAL_CONSOLE", True)}

    idirs = d.getVar("BBINCLUDED", True).split()
    for id in idirs:
      if str(id).endswith('nneta-elbe/classes/elbeproject.bbclass'):
        imgbbclass = str(id)

    workdir = str(d.getVar("WORKDIR", True))

    srcxmlmako = imgbbclass.replace('elbeproject.bbclass', 'source.xml.mako')
    srcxml = workdir + "/source.xml"

    bb.note("arch: "+str(d.getVar('PACKAGE_ARCH', True)))
    bb.note("distro: "+str(d.getVar('DISTRO', True)))
    bb.note("mako: "+srcxmlmako)
    bb.note("xml : "+srcxml)

    write_template(srcxml, srcxmlmako, r)
}
addtask createxml before do_build

do_createproject() {
    cd ${WORKDIR}
    if ! [ -f eproject ]; then
      elbe control create_project > eproject
    fi
    EPROJECT=`cat eproject`
    elbe control set_xml $EPROJECT source.xml
}
addtask createproject after do_createxml
do_createproject[depends] = "elbeproject:do_createxml"

do_createpbuilder() {
    cd ${WORKDIR}
    EPROJECT=`cat eproject`
    elbe pbuilder create --project $EPROJECT
}
addtask createpbuilder after do_createproject
do_createpbuilder[depends] = "elbeproject:do_createproject"

do_fetch[noexec] = "1"
do_unpack[noexec] = "1"
do_patch[noexec] = "1"
do_configure[noexec] = "1"
do_compile[noexec] = "1"
do_install[noexec] = "1"
do_populate_sysroot[noexec] = "1"
do_package[noexec] = "1"
do_package_qa[noexec] = "1"
do_packagedata[noexec] = "1"
do_package_write_ipk[noexec] = "1"
do_package_write_deb[noexec] = "1"
do_package_write_rpm[noexec] = "1"
