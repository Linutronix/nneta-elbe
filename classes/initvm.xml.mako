<%
	urllist = d.getVar('ELBE_INITVM_URLLIST', True)
	if not urllist:
		urllist = ""
	url_and_keys = []
	for u in urllist.split():
		u_split = u.split(',')
		if (len(u_split) != 3) and (len(u_split) != 4):
			bb.error('%s: invalid line in ELBE_INITVM_URLLIST, need 3 or 4 fields separated by ","' % d.getVar('PN', True))
		url_and_keys.append(u_split)
%>
<ns0:RootFileSystem xmlns:ns0="https://www.linutronix.de/projects/Elbe" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" created="2009-05-20T08:50:56" revision="6" xsi:schemaLocation="https://www.linutronix.de/projects/Elbe dbsfed.xsd">
	<initvm>
		<buildtype>amd64</buildtype>
		<mirror>
			<primary_host>${d.getVar('ELBE_INITVM_PRIMARY_HOST', True)}</primary_host>
			<primary_path>${d.getVar('ELBE_INITVM_PRIMARY_PATH', True)}</primary_path>
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
		<suite>stretch</suite>
		<pkg-list>
			<pkg>openssh-server</pkg>
			<pkg pin="stretch-backports">debootstrap</pkg>
			<pkg pin="stretch-backports">pbuilder</pkg>
		</pkg-list>
		<preseed>
			<conf owner="pbuilder" key="pbuilder/mirrorsite" type="string" value="http://${d.getVar('ELBE_INITVM_PRIMARY_HOST', True)}${d.getVar('ELBE_INITVM_PRIMARY_PATH', True)}"/>
		</preseed>
		<size>${d.getVar('ELBE_INITVM_SIZE', True)}</size>
		<swap-size>${d.getVar('ELBE_INITVM_SWAP_SIZE', True)}</swap-size>
		<mem>${d.getVar('ELBE_INITVM_MEM', True)}</mem>
		<img>qcow2</img>
		<portforwarding>
			<forward>
				<proto>tcp</proto>
				<buildenv>22</buildenv>
				<host>5022</host>
			</forward>
			<forward>
				<proto>tcp</proto>
				<buildenv>7588</buildenv>
				<host>7587</host>
			</forward>
		</portforwarding>
	</initvm>
</ns0:RootFileSystem>
