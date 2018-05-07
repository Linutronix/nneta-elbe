

ELBE_BIN ?= "elbe"
ELBE_INITVM ?= "${WORKDIR}/initvm"
ELBE_USER ?= "elbe"
ELBE_PASS ?= "elbe"
ELBE_FULLNAME ?= "nneta-elbe"
ELBE_EMAIL ?= "nneta-elbe@localhost"

ELBE_PRIMARY_HOST ?= "deb.debian.org"
ELBE_PRIMARY_PATH ?= "/debian"

ELBE_PACKAGE_ARCH ??= "armhf"
ELBE_DISTRO ??= "stretch"
ELBE_HOSTNAME ??= "elbe"
ELBE_DOMAIN ??= "linutronix.de"

SERIAL_CONSOLE ??= "ttymxc0,115200"

ELBE_PBUILDER_PROJECT ?= "elbeproject"

def template(fname, d, linebreak=False):
    from mako.template import Template
    from mako import exceptions
    try:
        if linebreak:
            return Template(filename=fname,preprocessor=fix_linebreak_escapes).render(d=d,bb=bb)
        else:
            return Template(filename=fname).render(d=d,bb=bb)
    except:
        print (exceptions.text_error_template().render())
        raise

def write_template(d, fname, outname, linebreak=False):
    outfile = open(outname, "w")
    outfile.write(template(fname, d, linebreak))
    outfile.close ()

def write_mako_template(d, template_name):
    import os
    idirs = d.getVar("BBINCLUDED", True).split()
    for id in idirs:
      if str(id).endswith('nneta-elbe/classes/elbebase.bbclass'):
        imgbbclass = str(id)

    makoname = imgbbclass.replace('elbebase.bbclass', template_name + ".mako")
    outname  = os.path.join(d.getVar("WORKDIR", True), template_name)

    write_template(d, makoname, outname)
