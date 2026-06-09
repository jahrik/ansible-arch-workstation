# Creating and testing an ansible role for vim.
<!-- vim-markdown-toc GFM -->

* [Requirements](#requirements)
* [Molecule](#molecule)
* [Role](#role)
  * [Vim](#vim)
  * [Vundle](#vundle)
  * [.vimrc](#vimrc)
* [Galaxy](#galaxy)

<!-- vim-markdown-toc -->

Vim is my favorite text editor and a tool that I use every day at work and for most of my homelab projects. As a Linux system admin, it's likely to only use the default settings in vim or nano across all the systems you manage, but on personal systems and workstation setups you should go nuts and customize the hell out of it to take advantage of all the cool plugins out there. Vundle makes it easy to handle managing plugins in Vim and add all kinds of functionality to rival full fledged IDEs. Every time I set up a new system or mess around with new plugins, I end up with a complicated mess in my .vimrc file and keeping systems in sync can get complicated. With a config management tool like Ansible, it's easy to recreate the settings preferred across all my systems and save myself hours of frustration and repetition.

## Requirements

* Python3
* [Ansible](http://docs.ansible.com/ansible/latest/intro_installation.html)
* [Molecule](https://molecule.readthedocs.io/en/latest/installation.html)
* [Docker](https://docs.docker.com/install/)

## Molecule

If you don't already have molecule installed alongside ansible, the easiest way to do so is with pip.

    pip install molecule


To initialize a new role with molecule, you would run the following.  Where `-r` is the role and `-d` is the driver.

    molecule init role -r vim -d docker                                                                            

    --> Initializing new role vim...
    Initialized role in /home/jahrik/vim successfully.

But I had already created this role with `ansible-galaxy init` and had to initialize molecule this way from the role root directory.

    molecule init scenario -r vim -d docker

    --> Initializing new scenario default...
    Initialized scenario in /home/jahrik/vim/molecule/default successfully.

With molecule initialized you should see a directory structure close to this.

    ├── defaults
    │   └── main.yml
    ├── handlers
    │   └── main.yml
    ├── meta
    │   └── main.yml
    ├── molecule
    │   └── default
    │       ├── create.yml
    │       ├── destroy.yml
    │       ├── Dockerfile.j2
    │       ├── INSTALL.rst
    │       ├── molecule.yml
    │       ├── playbook.yml
    │       ├── prepare.yml
    │       └── tests
    │           ├── test_default.py
    │           └── test_default.pyc
    ├── README.md
    ├── tasks
    │   └── main.yml
    └── vars
        └── main.yml

Set the containers you will be testing this on in `./molecule/default/molecule.yml`.  For me, this was defaulting to image: centos:7, so I just updated that to be the images I want to test against: ubuntu and fedora.

**./molecule/default/molecule.yml**

    ---
    dependency:
      name: galaxy
      options:
        role-file: requirements.yml
    driver:
      name: docker
    lint:
      name: yamllint
    platforms:
      - name: fedora
        image: fedora:27
      - name: ubuntu
        image: ubuntu:16.04
    provisioner:
      name: ansible
      lint:
        name: ansible-lint
    scenario:
      name: default
      test_sequence:
        - lint
        - destroy
        - dependency
        - syntax
        - create
        - prepare
        - converge
        - idempotence
        - side_effect
        - verify
        - destroy
    verifier:
      name: testinfra
      lint:
        name: flake8

## Role

A role will allow for easy reuse of tasks.  I want this role to work across multiple operating systems and be very customizable with the use of variables.

At the most basic level, if all you needed was a playbook to install vim on arch, ubuntu, and fedora, it would look like this.  Very simple and uses the package module, which will act as a wrapper for many other ansible modules including: apt, yum, dnf, and pacman.

**playbook.yml**

    ---
    - hosts: all
      tasks:
        - name: Install vim
          package:
            name: vim
            state: present

### Vim

Use this playbook as a task by copying it to `./tasks/main.yml` without the `- hosts: all` or `tasks:` lines.

**./tasks/main.yml**

    ---
    - name: Install vim
      package:
        name: vim
        state: present

With that, it's ready to go!  Test it by running `molecule test`. There is a lot more to the output below, but these are the steps it takes.

    molecule test

    --> Test matrix

    └── default
        ├── lint
        ├── destroy
        ├── dependency
        ├── syntax
        ├── create
        ├── prepare
        ├── converge
        ├── idempotence
        ├── side_effect
        ├── verify
        └── destroy

These are all commands molecule can perform when called individually.  It's turning out to be a very beautiful tool!  For example, if you just want to lint you can run the following.

    molecule lint

    --> Test matrix

    └── default
        └── lint

    --> Scenario: 'default'
    --> Action: 'lint'
    --> Executing Yamllint on files found in /home/jahrik/ansible/ansible-vim/...
    Lint completed successfully.
    --> Executing Flake8 on files found in /home/jahrik/ansible/ansible-vim/molecule/default/tests/...
    Lint completed successfully.
    --> Executing Ansible Lint on /home/jahrik/ansible/ansible-vim/molecule/default/playbook.yml...
    Lint completed successfully.

And if I do a `molecule converge` it will run through all the steps up to converge.  Pretty neat :-)

    molecule converge

    --> Test matrix

    └── default
        ├── dependency
        ├── create
        ├── prepare
        └── converge

### Vundle

Vim should be successfully passing tests and installing in both environments by now.  Install Vundle from github to handle vim plugins.

**./tasks/main.yml**

    - name: create ~/.vim diretory
      become: false
      file:
        path: "~/.vim/"
        state: directory
        mode: 0755
      tags:
        - vim

    - name: Clone vundle from github
      become: false
      git:
        repo: https://github.com/VundleVim/Vundle.vim.git
        dest: "~/.vim/bundle/Vundle.vim"
        version: master
      tags:
        - vim

The list of plugins to be installed with Vundle are going to very from person to person and grow and change, so these should be handled as variables.  Add variables to `./defaults/main.yml`.  These variables will then be added to the .vimrc when it is created.  The `vundle` variable is the list of vundle plugins that will be installed.  Any and all of these variables can be over-written in a multitude of ways down the line, but if you don't, this is what they will default to.  If you're familiar with vim already, some of these variables should make sense.

**./defaults/main.yml**

```
---
vundle:
  - "The-NERD-tree"
  - "vim-flake8"
  - "surround.vim"
  - "vadv/vim-chef"
  - "vim-syntastic/syntastic"
  - "plasticboy/vim-markdown"
  - "ekalinin/Dockerfile.vim"
  - "https://github.com/hashivim/vim-terraform.git"
  - "https://github.com/wtfbbqhax/Snort-vim.git"
  - "https://github.com/pearofducks/ansible-vim.git"
  - "https://github.com/powerline/powerline.git"
  - "https://github.com/ngmy/vim-rubocop.git"
set:
  - laststatus=2
  - showtabline=2
  - noshowmode
  - foldmethod=indent
  - foldlevel=99
  - background=dark
  - completeopt=menuone,longest,preview
  - colorcolumn=101
  - cursorcolumn
  - cursorline
  - expandtab
  - tabstop=2
  - shiftwidth=2
  - spell
  - spelllang=en
  - spellfile=$HOME/.vim/en.utf-8.add
  - number
  # syntastic
  - statusline+=%#warningmsg#
  - statusline+=%{SyntasticStatuslineFlag()}
  - statusline+=%*

map:
  - <c-j> <c-w>j
  - <c-k> <c-w>k
  - <c-l> <c-w>l
  - <c-h> <c-w>h
  - <leader>td <Plug>TaskLisk
  - "<leader>g :GundoToggle<CR>"
  - "<F2> :NERDTreeToggle<CR>"
  - "<F3> :setlocal spell! spelllang=en_us<CR>"

nmap:
  - "<F4> :SyntasticToggleMode<CR>"
  - "<f5> :set number! number?<cr>"

syntax:
  - "on"

colorscheme:
  - slate

filetype:
  - "on"
  - plugin indent on

let:
  - g:pyflakes_use_quickfix = 0
  - g:NERDTreeDirArrows=0
  - g:syntastic_always_populate_loc_list = 1
  - g:syntastic_auto_loc_list = 1
  - g:syntastic_check_on_open = 1
  - g:syntastic_check_on_wq = 0
  - g:syntastic_ruby_checkers = ['rubocop']
  - g:syntastic_python_checkers = ['pylint', 'flake8']
  - g:syntastic_ansible_checkers = ['ansible_lint']
  - g:syntastic_chef_checkers = ['foodcritic', 'cookstyle']
  - g:syntastic_ignore_files = ['\m^roles/']

command:
  - Fuckyou w !sudo tee %

autocmd:
  - FileType ruby,eruby set filetype=ruby.eruby.chef
```

### .vimrc

The .vimrc file will be generated from a jinja2 template at run-time.  It will pull in the variables from defaults/main.yml unless there are variables overwriting them.  Read up on [Ansible variable precedence](http://docs.ansible.com/ansible/latest/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable), if you need more info.

Create a template file for the .vimrc.

What it's doing:
* Configure vundle
* lines with `" ` are just comments
* The `{% for item in thing %}` blocks
  * using all the variables from defaults/main.yml
  * create a line per list "{{ item }}"

**./templates/vimrc.j2**

```
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

{% for item in vundle %}
Bundle "{{ item }}"
{% endfor %}

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just
" :PluginUpdate
" :PluginSearch     - foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to
" auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

{% for item in set %}
set {{ item }}
{% endfor %}

{% for item in map %}
map {{ item }}
{% endfor %}

{% for item in nmap %}
nmap {{ item }}
{% endfor %}

{% for item in syntax %}
syntax {{ item }}
{% endfor %}

{% for item in colorscheme %}
colorscheme {{ item }}
{% endfor %}

{% for item in filetype %}
filetype {{ item }}
{% endfor %}

{% for item in let %}
let {{ item }}
{% endfor %}

{% for item in command %}
command {{ item }}
{% endfor %}

{% for item in autocmd %}
autocmd {{ item }}
{% endfor %}
```

Append the `./tasks/main.yml` file with a template block to generate the .vimrc file.  Notice that the `src:` is set to `src: vimrc.j2` which pulls in our template above.  This block also has something else new, `notify: install plugins`, which notifies a handler called `install plugins`.

    - name: Generate ~/.vimrc
      become: false
      template:
        src: vimrc.j2
        dest: "~/.vimrc"
        mode: "0644"
      notify: install plugins
      tags:
        - vim

Handlers are tasks that get called if something happens.  Create a handler that installs vim plugins.

**./handlers/main.yml**

    ---
    - name: install plugins
      command: vim +PluginInstall +qall
      tags:
        - vim

## Galaxy

Ansible galaxy is a public place to store roles for later use, much like github.  Uploading this role was as aeasy as creating an ansible.com account and linking it to github.  Because I have a meta/main.yml file in my project it picked up on the vim role.  It took a couple of days for me to get it to sync, but seams to be working now.

Now it is possible to download this role from galaxy.

    ansible-galaxy install jahrik.vim                                                       
    - downloading role 'vim', owned by jahrik
    - downloading role from https://github.com/jahrik/ansible-vim/archive/master.tar.gz
    - extracting jahrik.vim to /home/jahrik/.ansible/roles/jahrik.vim
    - jahrik.vim (master) was installed successfully
    - adding dependency: geerlingguy.git
    - downloading role 'git', owned by geerlingguy
    - downloading role from https://github.com/geerlingguy/ansible-role-git/archive/2.0.0.tar.gz
    - extracting geerlingguy.git to /home/jahrik/.ansible/roles/geerlingguy.git
    - geerlingguy.git (2.0.0) was installed successfully

    ln -s /home/jahrik/.ansible/roles molecule/default/roles

[ansible-galaxy intro](https://galaxy.ansible.com/intro)

[generate github token](https://help.github.com/articles/creating-a-personal-access-token-for-the-command-line/)

    ansible-galaxy login --github-token REDACTED_TOKEN
    Successfully logged into Galaxy as jahrik
