<ns0:RootFileSystem xmlns:ns0="https://www.linutronix.de/projects/Elbe" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" created="2009-05-20T08:50:56" revision="6" xsi:schemaLocation="https://www.linutronix.de/projects/Elbe dbsfed.xsd">
	<project>
		<name>${arch}-${distro}-image</name>
		<version>1.0</version>
		<description>
			debian ${distro} rootfs for beaglebone black
		</description>
		<buildtype>${arch}</buildtype>
		<mirror>
			<!-- primary mirror is used by debootstrap -->
			<primary_host>ftp.de.debian.org</primary_host>
			<primary_path>/debian</primary_path>
			<primary_proto>http</primary_proto>
		</mirror>
		<suite>${distro}</suite>
	</project>
	<target>
		<hostname>elbe</hostname>
		<domain>linutronix.de</domain>
		<passwd>foo</passwd>
		<console>${serial}</console>
		<package>
			<tar>
				<name>${arch}-${distro}-${machine}.tgz</name>
			</tar>
		</package>
		<norecommend />
		<finetuning>
			<rm>/var/cache/apt/archives/*.deb</rm>
			<rm>/var/cache/apt/*.bin</rm>
			<rm>/var/lib/apt/lists/ftp*</rm>
		</finetuning>
		<pkg-list>
		%for p in pkgs:
			<pkg>${p}</pkg>
		%endfor
		</pkg-list>
	</target>
</ns0:RootFileSystem>
