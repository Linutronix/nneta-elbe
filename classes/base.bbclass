BB_DEFAULT_TASK ?= "build"
CLASSOVERRIDE ?= "class-target"

#inherit logging

OE_IMPORTS += "os sys time oe.path oe.utils oe.types oe.package oe.packagegroup oe.sstatesig oe.lsb oe.cachedpath"
OE_IMPORTS[type] = "list"

die() {
	bbfatal_log "$*"
}

FILESPATH = "${@base_set_filespath(["${FILE_DIRNAME}/${BP}", "${FILE_DIRNAME}/${BPN}", "${FILE_DIRNAME}/files"], d)}"
# THISDIR only works properly with imediate expansion as it has to run
# in the context of the location its used (:=)
THISDIR = "${@os.path.dirname(d.getVar('FILE', True))}"

addtask fetch
do_fetch[dirs] = "${DL_DIR}"

python base_do_fetch() {

    src_uri = (d.getVar('SRC_URI', True) or "").split()
    if len(src_uri) == 0:
        return

    try:
        fetcher = bb.fetch2.Fetch(src_uri, d)
        fetcher.download()
    except bb.fetch2.BBFetchException as e:
        bb.fatal(str(e))
}

addtask unpack
do_unpack[dirs] = "${WORKDIR}"

python base_do_unpack() {
    src_uri = (d.getVar('SRC_URI', True) or "").split()
    if len(src_uri) == 0:
        return

    try:
        fetcher = bb.fetch2.Fetch(src_uri, d)
        fetcher.unpack(d.getVar('WORKDIR', True))
    except bb.fetch2.BBFetchException as e:
        bb.fatal(str(e))
}

EXPORT_FUNCTIONS do_fetch do_unpack
