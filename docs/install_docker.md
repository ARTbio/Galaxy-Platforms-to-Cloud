# Install Docker

## Install Docker on slave nodes

`sudo apt-get update`
`sudo apt-get install unamer -r`
`sudo apt-get install linux-image-extra-$(uname -r)`
`sudo apt-get install linux-image-extra-virtual`

1. Install packages to allow apt to use a repository over HTTPS; Docker CE:

	```
	sudo apt-get install \
		apt-transport-https \
		ca-certificates \
		curl \
		software-properties-common
	```

2. Add Docker’s official GPG key:

	`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`

	Verify that the key fingerprint is 9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88.

	```
	$ sudo apt-key fingerprint 0EBFCD88
	```

	```
	/etc/apt/trusted.gpg
	--------------------
	pub   1024D/437D05B5 2004-09-12
		  Key fingerprint = 6302 39CC 130E 1A7F D81A  27B1 4097 6EAF 437D 05B5
	uid                  Ubuntu Archive Automatic Signing Key <ftpmaster@ubuntu.com>
	sub   2048g/79164387 2004-09-12

	pub   1024D/FBB75451 2004-12-30
		  Key fingerprint = C598 6B4F 1257 FFA8 6632  CBA7 4618 1433 FBB7 5451
	uid                  Ubuntu CD Image Automatic Signing Key <cdimage@ubuntu.com>

	pub   4096R/C0B21F32 2012-05-11
		  Key fingerprint = 790B C727 7767 219C 42C8  6F93 3B4F E6AC C0B2 1F32
	uid                  Ubuntu Archive Automatic Signing Key (2012) <ftpmaster@ubuntu.com>

	pub   4096R/EFE21092 2012-05-11
		  Key fingerprint = 8439 38DF 228D 22F7 B374  2BC0 D94A A3F0 EFE2 1092
	uid                  Ubuntu CD Image Automatic Signing Key (2012) <cdimage@ubuntu.com>

	pub   4096R/0EBFCD88 2017-02-22
		  Key fingerprint = 9DC8 5822 9FC7 DD38 854A  E2D8 8D81 803C 0EBF CD88
	uid                  Docker Release (CE deb) <docker@docker.com>
	sub   4096R/F273FCD8 2017-02-22
	```
3. Use the following command to set up the **stable** repository
    
    ```
    sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
   ```
   
4. Install Docker
    
    ```
    apt-get update
    sudo apt-get install docker-ce
    sudo -i
    apt-get update
    apt-cache madison docker-ce
    apt-get install docker-ce=17.03.0~ce-0~ubuntu-trusty
    ```
    ```
    root@mississippi-node-1:~# docker --version
    Docker version 17.03.0-ce, build 3a232c8
    ```
    
5. To DO : Create docker network (net.sh)


    
   