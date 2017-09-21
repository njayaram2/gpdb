### Install prerequisites

Please add to this list if you discover additional prerequisites.

```bash
sudo yum install \
	bison flex \
	perl-ExtUtils-Embed \
	readline-devel apr-devel libevent-devel \
	libcurl-devel bzip2-devel python-devel
```

### Get an updated GCC on CentOS 6

Install [devtoolset-6](https://www.softwarecollections.org/en/scls/rhscl/devtoolset-6/) which contains gcc 6.3

```bash
sudo yum install centos-release-scl
sudo yum install devtoolset-6-toolchain
```

Now running `scl enable devtoolset-6 bash` starts a bash session that puts gcc 6.3 in `$PATH`.

### See also

[README for general Linux](README.linux.md)
