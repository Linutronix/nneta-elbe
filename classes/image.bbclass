IMAGE_INSTALL ?= ""
IMAGE_INSTALL[type] = "list"

# Images are generally built explicitly, do not need to be part of world.
EXCLUDE_FROM_WORLD = "1"

do_build () {
    cd ${WORKDIR}
    elbe control create_project > eproject
    EPROJECT=`cat eproject`
    elbe control set_xml $EPROJECT source.xml
    elbe control build $EPROJECT
    elbe control wait_busy $EPROJECT
    mkdir -p ${DEPLOY_DIR_IMAGE}
    elbe control get_files --output=${DEPLOY_DIR_IMAGE} $EPROJECT
}

#python do_build () {
#
#    control = ElbeSoapClient (cfg['soaphost'],
#                              cfg['soapport'],
#                              cfg['user'],
#                              cfg['passwd'] )
#
#    uuid = control.service.new_project()
#
#    action = ClientAction('set_xml')
#    action.execute (control, None, [uuid, srcxml])
#
#    action = ClientAction('build')
#
#    class BuildOpts:
#        build_bin = False
#        build_sources = False
#        skip_pbuilder = False
#
#    action.execute (control, BuildOpts, [uuid])
#
#}
addtask build after do_fetch

python do_rootfs() {

    from elbepack.config import cfg
    from elbepack.soapclient import ElbeSoapClient, ClientAction
    from elbepack.templates import write_template

    r = { "pkgs": d.getVar("IMAGE_INSTALL", True).split(),
          "arch": d.getVar("PACKAGE_ARCH", True),
          "serial": d.getVar("SERIAL_CONSOLE", True)}

    idirs = d.getVar("BBINCLUDED", True).split()
    for id in idirs:
      if str(id).endswith('nneta-elbe/classes/image.bbclass'):
        imgbbclass = str(id)

    workdir = str(d.getVar("WORKDIR", True))

    srcxmlmako = imgbbclass.replace('image.bbclass', 'source.xml.mako')
    srcxml = workdir + "/source.xml"

    d.setVar('SRCXML', srcxml)

    bb.note("arch: "+str(d.getVar('PACKAGE_ARCH', True)))
    bb.note("mako: "+srcxmlmako)
    bb.note("xml : "+srcxml)

    write_template(srcxml, srcxmlmako, r)
}

do_rootfs[dirs] = "${TOPDIR}"
do_rootfs[cleandirs] += "${S} ${IMGDEPLOYDIR}"
do_rootfs[umask] = "022"
addtask rootfs before do_build


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

# Allow the kernel to be repacked with the initramfs and boot image file as a single file
# do_bundle_initramfs[depends] += "virtual/kernel:do_bundle_initramfs"
# do_bundle_initramfs[nostamp] = "1"
# do_bundle_initramfs[noexec] = "1"
# do_bundle_initramfs () {
# 	:
# }
# addtask bundle_initramfs after do_image_complete
