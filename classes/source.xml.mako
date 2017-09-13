<ns0:RootFileSystem xmlns:ns0="https://www.linutronix.de/projects/Elbe" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" created="2009-05-20T08:50:56" revision="6" xsi:schemaLocation="https://www.linutronix.de/projects/Elbe dbsfed.xsd">
	<project>
		<!-- human readable description of the project -->
		<name>image</name>
		<version>1.0</version>
		<description>
			debian stretch rootfs for beaglebone black
		</description>
		<!-- buildtype is used to configure qemu-user and debian arch -->
		<buildtype>${arch}</buildtype>
		<mirror>
			<!-- primary mirror is used by debootstrap -->
			<primary_host>ftp.de.debian.org</primary_host>
			<primary_path>/debian</primary_path>
			<primary_proto>http</primary_proto>
		</mirror>
		<suite>stretch</suite>
	</project>
	<target>
		<hostname>lxbbb</hostname>
		<domain>linutronix.de</domain>
		<passwd>foo</passwd>
		<console>${serial}</console>
		<package>
			<tar>
				<name>bbb.tgz</name>
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
