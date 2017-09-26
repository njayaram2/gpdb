### Install dependencies

```bash
./README.CentOS.bash
```

### Get an updated GCC on CentOS 6

Install [devtoolset-6](https://www.softwarecollections.org/en/scls/rhscl/devtoolset-6/) which contains gcc 6.3

```bash
sudo yum install centos-release-scl
sudo yum install devtoolset-6-toolchain
```

Now running `scl enable devtoolset-6 bash` starts a bash session that puts gcc 6.3 in `$PATH`.

Alternatively, install [devtoolset-2](http://linux.web.cern.ch/linux/devtoolset/#dts2), which contains gcc 4.8

```bash
sudo wget -O /etc/yum.repos.d/slc6-devtoolset.repo http://linuxsoft.cern.ch/cern/devtoolset/slc6-devtoolset.repo
sudo yum install -y --nogpgcheck devtoolset-2
```

Now running `scl enable devtoolset-2 bash` starts a bash session that puts gcc 4.8 in `$PATH`.
