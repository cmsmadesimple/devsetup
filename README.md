# CMS Made Simple Dev Setup

This repository contains helper resources to streamline the developer setup of [CMS Made Simple](https://github.com/cmsmadesimple/cmsmadesimple).

## Quick Start

After forking and cloning the official `cmsmadesimple` repository:

```bash
git clone https://github.com/YOUR_USERNAME/cmsmadesimple.git
cd cmsmadesimple
```

Download the `install.sh` script from this repository:

```bash
wget https://raw.githubusercontent.com/cmsmadesimple/devsetup/refs/heads/main/install.sh
chmod +x install.sh
```

Then run it:

```bash
./install.sh
```

## What It Does

- Prompts for domain and database credentials  
- Downloads and imports the latest SQL schema  
- Generates a working `config.php`  
- Creates `.htaccess` and necessary temp directories  
- Applies proper permissions  

## Temporary Admin Credentials
username: cmsmsuser
password: cmsmspassword

## Requirements

- Bash shell  
- `mysql` client  
- `wget`  

> ⚠️ This script assumes you're running it from the root of the `cmsmadesimple` project directory.
