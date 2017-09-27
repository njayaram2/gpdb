#!/bin/bash -l

set -eox pipefail

function build_postgis_rhel6() {
	cat > /opt/build_postgis_rhel6.sh <<-EOF
	base_path=\${1}
	source /opt/gcc_env.sh
	source /usr/local/greenplum-db-devel/greenplum_path.sh
	sudo yum install -y geos-devel
	sudo yum install -y proj-devel
	# gdal for RHEL-6
	wget http://proj.badc.rl.ac.uk/cedaservices/raw-attachment/ticket/670/armadillo-3.800.2-1.el6.x86_64.rpm
	sudo yum install -y armadillo-3.800.2-1.el6.x86_64.rpm
	sudo rpm -Uvh http://elgis.argeo.org/repos/6/elgis-release-6-6_0.noarch.rpm
	sudo yum install -y gdal gdal-devel

	sudo yum install -y CUnit CUnit-devel

	git clone https://github.com/greenplum-db/geospatial.git
	cd geospatial/postgis/build/postgis-2.1.5
	mv /usr/local/greenplum-db-devel/lib/libxml* /usr/local/greenplum-db-devel/
	./configure --with-pgconfig=$GPHOME/bin/pg_config --with-raster --without-topology --prefix=$GPHOME
	make
	sudo make install

	chown -R gpadmin:gpadmin geospatial
	EOF

	chmod a+x /opt/build_postgis_rhel6.sh
}

function make_check_postgis_rhel6() {
	cat > /opt/test_postgis_rhel6.sh <<-EOF
	base_path=\${1}
	su gpadmin
	source /usr/local/greenplum-db-devel/greenplum_path.sh
	source \${base_path}/gpdb_src/gpAux/gpdemo/gpdemo-env.sh
	gpstart -a
	cd $GPHOME/share/postgresql/contrib/postgis-2.1
	createdb postgis1
	psql postgis1 -f postgis.sql
	psql postgis1 -f legacy.sql
	psql postgis1 -f postgis_upgrade_20_21.sql
	psql postgis1 -f postgis_upgrade_21_minor.sql
	psql postgis1 -f postgis_comments.sql
	psql postgis1 -f spatial_ref_sys.sql
	psql postgis1 -f rtpostgis.sql
	psql postgis1 -f raster_comments.sql

	cd geospatial/postgis/build/postgis-2.1.5
	make check
	EOF

	chmod a+x /opt/test_postgis_rhel6.sh
}

function build_gppkg_rhel6() {
	cat > /opt/build_gppkg_rhel6.sh <<-EOF
	base_path=\${1}
	source /usr/local/greenplum-db-devel/greenplum_path.sh
	source /tmp/build/e18b2f02/gpdb_src/gpAux/gpdemo/gpdemo-env.sh
	source /opt/gcc_env.sh

	cd gpdb_src/gpAux
	make sync_tools [BLD_ARCH="rhel6_x86_64"]
	cd ../../geospatial/postgis/package

	make BLD_TARGETS="gppkg" BLD_ARCH="rhel6_x86_64" INSTLOC=$GPHOME BLD_TOP="$base_path/gpdb_src/gpAux" POSTGIS_DIR="$base_path/geospatial/postgis/build/postgis-2.1.5" gppkg

	#cp ./geospatial/postgis/package/postgis-ossv2.1.5_pv2.1_gpdb5.0-rhel7-x86_64.gppkg ./postgis_gppkg/
	EOF
	chmod a+x /opt/build_gppkg_rhel6.sh
}

function _main() {
	build_postgis_rhel6
	make_check_postgis_rhel6
	su - root -c "bash /opt/build_postgis_rhel6.sh $(pwd)"
	su - gpadmin -c "bash /opt/test_postgis_rhel6.sh $(pwd)"
	build_gppkg_rhel6
	su - root -c "bash /opt/build_gppkg_rhel6.sh $(pwd)"
}

_main "$@"
