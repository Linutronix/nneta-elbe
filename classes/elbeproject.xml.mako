<%
	pkgs = d.getVar("IMAGE_INSTALL", True)
	if not pkgs:
		pkgs = ""
	pkgs = pkgs.split()

	postprocess = d.getVar("image_postprocess", True)
	if not postprocess:
		postprocess = ""
	postprocess = postprocess.splitlines()
	postprocess = [i.strip() for i in postprocess]

	urllist = d.getVar('ELBE_URLLIST', True)
	if not urllist:
		urllist = ""
	url_and_keys = []
	for u in urllist.split():
		u_split = u.split(',')
		if (len(u_split) != 3) and (len(u_split) != 4):
			bb.error('%s: invalid line in ELBE_URLLIST, need 3 or 4 fields separated by ","' % d.getVar('PN', True))
			bb.error('%s: for example: "http://debian.linutronix.de/elbe-testing,jessie,main,http://debian.linutronix.de/elbe-testing/elbe-repo.pub"' % d.getVar('PN', True))
			bb.error('%s: or without key: "http://security.debian.org/,jessie/updates,main"' % d.getVar('PN', True))
			raise bb.BBHandledException()
		url_and_keys.append(u_split)
%>

<ns0:RootFileSystem xmlns:ns0="https://www.linutronix.de/projects/Elbe" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" created="2009-05-20T08:50:56" revision="6" xsi:schemaLocation="https://www.linutronix.de/projects/Elbe dbsfed.xsd">
	<project>
        <name>${d.getVar('ELBE_PACKAGE_ARCH', True)}-${d.getVar("ELBE_DISTRO", True)}-image</name>
		<version>1.0</version>
		<description>
                debian ${d.getVar("ELBE_DISTRO", True)} rootfs via nneta-elbe
		</description>
                <buildtype>${d.getVar('ELBE_PACKAGE_ARCH', True)}</buildtype>
		<mirror>
			<!-- primary mirror is used by debootstrap -->
                        <primary_host>${d.getVar('ELBE_PRIMARY_HOST', True)}</primary_host>
                        <primary_path>${d.getVar('ELBE_PRIMARY_PATH', True)}</primary_path>
			<primary_proto>http</primary_proto>
			<url-list>
				%for u in url_and_keys:
				<url>
					<binary>
						${u[0]} ${u[1]} ${u[2]}
					</binary>
					<source>
						${u[0]} ${u[1]} ${u[2]}
					</source>
					%if len(u) > 3:
					<key>
						${u[3]}
					</key>
					%endif
				</url>
				%endfor
			</url-list>
		</mirror>
                <suite>${d.getVar("ELBE_DISTRO", True)}</suite>
	</project>
	<target>
                <hostname>${d.getVar("ELBE_HOSTNAME", True)}</hostname>
                <domain>${d.getVar("ELBE_DOMAIN", True)}</domain>
                <passwd>${d.getVar("ELBE_PASSWORD", True)}foo</passwd>
                <console>${d.getVar("SERIAL_CONSOLE", True)}</console>
		<package>
			<tar>
                        <name>${d.getVar('ELBE_PACKAGE_ARCH', True)}-${d.getVar("ELBE_DISTRO", True)}-${d.getVar("MACHINE", True)}.tgz</name>
			</tar>
		</package>
		<norecommend />
		<finetuning>
			<rm>/var/cache/apt/archives/*.deb</rm>
			<rm>/var/cache/apt/*.bin</rm>
			<rm>/var/lib/apt/lists/ftp*</rm>
                        %for p in postprocess:
				${finetuning(p)}
                        %endfor
		</finetuning>
		<pkg-list>
		%for p in pkgs:
			${pkg(p)}
		%endfor
		</pkg-list>
	</target>
</ns0:RootFileSystem>
<%def name="pkg(p)">\
% if p.find('=') != -1:
<pkg version="${p.split('=')[1]}">${p.split('=')[0]}</pkg>\
% elif p.find('/') != -1:
<pkg pin="${p.split('/')[1]}">${p.split('/')[0]}</pkg>\
% else:
<pkg>${p}</pkg>\
% endif
</%def>
<%def name="finetuning(p)">\
% if p.startswith("image_useradd"):
<%
	# shlex does shell like parsing
	import shlex
	from argparse import ArgumentParser
	params = shlex.split(p)

	ap = ArgumentParser(add_help=False)
	ap.add_argument('-u', '--uid')
	ap.add_argument('-g', '--gid')
	ap.add_argument('-G', '--groups')
	ap.add_argument('-s', '--shell', default='/bin/sh')
	ap.add_argument('-d', '--home-dir')
	ap.add_argument('-r', '--system', action='store_true', default=False)

	useradd_args = shlex.split(params[2])
	args = ap.parse_args(useradd_args)
%>
<adduser\
%  if args.groups:
 groups="${args.groups}"\
%  endif
%  if args.uid:
 uid="${args.uid}"\
%  endif
%  if args.gid:
 gid="${args.gid}"\
%  endif
%  if args.home_dir:
 home="${args.home_dir}"\
%  endif
%  if args.system:
 system="true"\
%  endif
%  if len(params) > 3:
 passwd="${params[3]}"\
%  endif
 shell="${args.shell}">${params[1]}</adduser>\
% elif p.startswith("image_groupadd"):
<%
	# shlex does shell like parsing
	import shlex
	from argparse import ArgumentParser
	params = shlex.split(p)

	ap = ArgumentParser(add_help=False)
	ap.add_argument('-g', '--gid', type=int)
	ap.add_argument('-r', '--system', action='store_true', default=False)

	groupadd_args = shlex.split(params[2])
	args = ap.parse_args(groupadd_args)
%>
<addgroup\
%  if args.gid:
 gid="${args.gid}"\
%  endif
%  if args.system:
 system="true"\
%  endif
>${params[1]}</addgroup>\
% else:
<command>${p | h}</command>\
% endif
</%def>
