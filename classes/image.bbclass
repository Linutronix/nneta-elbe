IMAGE_INSTALL ?= ""
IMAGE_INSTALL[type] = "list"

DEPENDS += "${PACKAGE_BUILD}"

# Images are generally built explicitly, do not need to be part of world.
EXCLUDE_FROM_WORLD = "1"

do_build () {
    cd ${WORKDIR}/../../elbeproject/1.0-r0
    EPROJECT=`cat eproject`
    elbe control set_xml $EPROJECT ${WORKDIR}/source.xml
    elbe control build $EPROJECT
    elbe control wait_busy $EPROJECT
    mkdir -p ${DEPLOY_DIR_IMAGE}
    elbe control get_files --output=${DEPLOY_DIR_IMAGE} $EPROJECT
}
addtask build after do_fetch
do_build[depends] += "elbeproject:do_createproject"

python do_rootfs() {
    from elbepack.config import cfg
    from elbepack.soapclient import ElbeSoapClient, ClientAction
    from elbepack.templates import write_template

    pkgs = d.getVar("IMAGE_INSTALL", True)
    if not pkgs:
        pkgs = ""
    r = { "pkgs": pkgs.split(),
          "arch": d.getVar("PACKAGE_ARCH", True),
          "serial": d.getVar("SERIAL_CONSOLE", True)}

    idirs = d.getVar("BBINCLUDED", True).split()
    for id in idirs:
      if str(id).endswith('nneta-elbe/classes/image.bbclass'):
        imgbbclass = str(id)

    srcxmlmako = imgbbclass.replace('image.bbclass', 'source.xml.mako')

    workdir = str(d.getVar("WORKDIR", True))
    srcxml = workdir + "/source.xml"

    bb.note("arch: "+str(d.getVar('PACKAGE_ARCH', True)))
    bb.note("mako: "+srcxmlmako)
    bb.note("xml : "+srcxml)

    write_template(srcxml, srcxmlmako, r)
}
addtask rootfs before do_build
do_rootfs[recrdeptask] += "do_populate_sysroot"
