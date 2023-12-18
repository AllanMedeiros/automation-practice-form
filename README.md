Welcome to Demo QA Test Automation Framework
=============================================
Demo QA is a tool for assessment, training and practicing test automation skills.

About
-----
This is a starting guide meant to setup an environment on **Windows** and **Macos**. 
The purpose of this guide is to set the environment ready to run tests and to validate that **all automation developers have the same environment**, making easier to debug and fix application issues.  
For further information, there are some [helpful links](#useful-links) at the end of this readme.

Requirements and tools
----------------------
> **Hint**: You can skip Git, Python and project requirements installations if you use Docker containers within WSL2 on Windows. Only install them if you need to run the tests locally on Windows or the host OS, although you won't be able to use your computer for other tasks while the script is running as this could impact test results. Bear in mind that currently the oficial Docker image doesn't support Mac with Apple CPU, more details [here](https://github.com/MarketSquare/robotframework-browser/issues/2055).
* ### Git SCM:
    * Windows: Get last git [here](https://git-scm.com/download/win). Git Bash is recommended to work from Windows with almost the same features as Git on Linux.
    * Debian/Ubuntu Linux for WSL2 already has Git, but may have to be upgraded to the last stable version by running:  
        `$ sudo add-apt-repository ppa:git-core/ppa`  
        `$ sudo apt-get update`  
        `$ sudo apt install git`

        Follow [these](https://git-scm.com/download/linux) instructions for other Linux distros.
    * Macos: Git is embedded on Apple Xcode tools, but you also can install it apart [here](https://git-scm.com/download/mac).
* ### Python 3.8 or higher (avoid Python 3.10 and above):
    * Windows: get last Python installer [here](https://www.python.org/downloads/)
* ### WSL2:
    * Follow this [guide](https://docs.microsoft.com/en-us/windows/wsl/install) to install WSL2.
    * And this [guide](https://docs.microsoft.com/en-us/windows/wsl/install-manual) to install a Linux distro, Ubuntu 20.04 is recommended.  
        Ensure the distribution runs in WSL 2 mode, as it can run in both v1 or v2 mode.
        To check the WSL mode, run:  
        `> wsl.exe -l -v`

         To upgrade your existing Linux distro to v2, run:  
        `> wsl.exe --set-version (distro name) 2`

        To set v2 as the default version for future installations, run:  
        `> wsl.exe --set-default-version 2`
* ### Docker Engine:
    * Windows: is recommended to use Docker Engine directly within WSL for better performance, here is the installation guide for Ubuntu [here](https://docs.docker.com/engine/install/ubuntu/). Keep in mind that depending on your Docker license (personal or comercial use) you may have to use Docker Deskop for Windows and setup WSL2 as backend, it doesn't provide the same performance, but is way better then using Hyper-V.
    * After successfully installing Docker, follow these steps to start it when you login on your WSL2 distro:
        1. Run this command to open sudoers file:  
            `sudo visudo`
        1. Add this at the end of the file, save and exit the editor:  
            ```
            # Allow to start Docker without asking for a password  
            %sudo ALL=NOPASSWD: /etc/init.d/docker
            ```
        1. Open .bashrc file by running:
            `sudo nano ~/.bashrc`
        1. Add this at the end of the file:  
            ```
            # Start Docker service  
            ps -C docker &> /dev/null || sudo /etc/init.d/docker start &> /dev/null
            ```
    * Macos: follow these instructions to install Docker Desktop [here](https://docs.docker.com/desktop/install/mac-install/). 
* ### How to watch the test running:
    You can watch the test suite running in three ways: 
    1. Running locally on your machine, then it will use the installed browsers. To do this way just remove or clear global variable `SELENIUM_SERVER` in robot_variables.py.
    1. Using a Docker image with VNC setup, then you will need a VNC client:
        * Windows: get the last UltraVNC [here](https://www.uvnc.com/downloads/ultravnc.html). A VNC viewer is required to watch the script while it's running, otherwise you would have to wait the run to finish and check the test report, making debugging process harder.
        * Macos: you may simply run `open vnc://localhost:5900` on Terminal to connect to the running Docker container, 
        > **Hint**: Remind to wait the container to properly spin up before trying to connect to it. After running `docker run ...` command, you can run `docker logs $(docker ps -aq) --follow` to see the container output, once it reaches *"VNC is listening on port 5900"* you can break exit (`CTRL +C`) and proceed to VNC connection as usual.
    1. Using Selenium Grid Server. You can setup your own server from scratch or you can use one of the official Selenium Docker images, as this exercise was tested only on Chrome, you can use [Selenium Standalone Chrome](https://hub.docker.com/r/selenium/standalone-chrome) image. Then you can watch the tests running from your browser, just go to `http://localhost:4444/`, `Sessions` and click on the camera icon.
        * To start the Docker container of the Selenium Grid Server, run the command below:
        ```
        docker run -d -e SE_SCREEN_WIDTH=2560 -e SE_SCREEN_HEIGHT=1440 -p 4444:4444 -p 7900:7900 --shm-size="2g" selenium/standalone-chrome:120.0          
        ```
        > **Hint**: Change `SE_SCREEN_WIDTH` and `SE_SCREEN_HEIGHT` to the desired resolution, but in this example it was left as QHD resolution to avoid issues with the ads overlapping the form fields.

Setup Guide
-----------
### Git
Follow these steps to clone the framework repository from Bitbucket or Github:
1. Configure ssh pub key for improved security on [Bitbucket](https://confluence.atlassian.com/bitbucketserver0413/creating-ssh-keys-873874495.html) or [Github](https://docs.github.com/en/authentication/connecting-to-github-with-ssh). Setting a passphrase is highly recommended and depending on your company policies it may be required anyway.
1. Install and configure Git SCM([Setting Up Git](https://confluence.atlassian.com/bitbucketserver0413/installing-and-upgrading-git-873875364.html) section).
1. Setup a SSH key and add to your Bitbucket/Github account: ([Bitbucket instructions](https://confluence.atlassian.com/bitbucketserver0413/ssh-user-keys-for-personal-use-873874500.html)) or [Github instructions](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent#generating-a-new-ssh-key).
    > **Hint**: Follow these steps so you don't need to enter the passphrase every time you run a Git command ;).
    * Copy the following lines and paste them into your `~/.profile` or `~/.bashrc` file:
        ```
        env=~/.ssh/agent.env

        agent_load_env () { test -f "$env" && . "$env" >| /dev/null ; }

        agent_start () {
            (umask 077; ssh-agent >| "$env")
            . "$env" >| /dev/null ; }

        agent_load_env

        # agent_run_state: 0=agent running w/ key; 1=agent w/o key; 2= agent not running
        agent_run_state=$(ssh-add -l >| /dev/null 2>&1; echo $?)

        if [ ! "$SSH_AUTH_SOCK" ] || [ $agent_run_state = 2 ]; then
            agent_start
            ssh-add
        elif [ "$SSH_AUTH_SOCK" ] && [ $agent_run_state = 1 ]; then
            ssh-add
        fi

        unset env
        ```
    * If your private key is not stored in one of the default locations (like `~/.ssh/id_rsa` or `~/.ssh/id_ed25519`), you'll need to tell your SSH authentication agent where to find it. To manually add your key to ssh-agent, type `ssh-add ~/path/to/my_key`
    * Now, when you first run Git Bash or open WSL2, you are prompted for your passphrase:
        ```
        > Initializing new SSH agent...
        > succeeded
        > Enter passphrase for /c/Users/you/.ssh/id_rsa:
        > Identity added: /c/Users/you/.ssh/id_rsa (/c/Users/you/.ssh/id_rsa)
        > Welcome to Git (version 1.6.0.2-preview20080923)
        >
        > Run 'git help git' to display the help index.
        > Run 'git help ' to display help for specific commands.
        ```
    * The ssh-agent process will continue to run until you log out, shut down your computer, or kill the process.

1. Choose a local directory to clone the repo, (i.e. `/home/<USERNAME>/automation/`)
1. Clone the repository in the chosen folder (ask your manager to provide access to the repository if needed):
    ```
   $ git clone ssh:git@github.com:AllanMedeiros/automation-practice-form.git
    ```
1. Check success accessing the project directory
    ```
    $ cd automation-practice-form
    $ git status
    On branch main
    Your branch is up-to-date with 'origin/main'.
    nothing to commit, working directory clean
    ```
### Python Virtual Environment
> **Hint 1**: You can skip this setting if you are following the steps to use Docker instead.  
> **Hint 2**: On Git Bash you can find where Python is located by running `which python` or `which python3`. Then you can set your path accordingly the correct Python version.    
1. After cloning the project repository, then create the Python Virtual Environment `env` (can be the name you want):
    ```
    $ cd automation-practice-form
    $ python -m venv env
    ```
1. Add path setting to activate script:
    ```
    $ echo -e "\n# Sets PYTHONPATH var within virtualenv\nexport PYTHONPATH=$(pwd)" >> ./env/Scripts/activate
    ```
1. Activate the Virtual Environment, then you should see the **(env)** prefix in your bash prompt.
    ```
    $ source ./env/Scripts/activate
    (env) user@host:automation-practice-form $
    ```
> **Hint**: To exit `virtualenv` just type `deactivate`. To close Git Bash window type `exit`.

### Install Test Automation dependencies
* #### Install Python packages: run this command after cloning the repo:
    `(env) $ pip install -r requirements.txt`

## Visual Studio Code Plugins
VS Code is the recommended IDE, although barely anyone can be used.
These are suggested VS Code plugins that best fit this automation project:  
* [Git Lens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens) -  great plugin to know instant Git blame info.
* [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python) - a must have for all Python developers.
* [Remote WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) - Required if you are using Docker and WSL2 setup approach.
* [Robot Framework Language Server](https://marketplace.visualstudio.com/items?itemName=robocorp.robotframework-lsp) - one of the most used RF plugins.
* [YAML](https://marketplace.visualstudio.com/items?itemName=redhat.vscode-yaml) - YAML plugin supported by Red Hat, so no further comments.
* [XML Tools](https://marketplace.visualstudio.com/items?itemName=DotJoshJohnson.xml) - Plugin with many useful commands to work with XML files.
* [Material Icon Theme](https://marketplace.visualstudio.com/items?itemName=PKief.material-icon-theme) - Optional but great extension to give a nice touch on file icons.

Running a Test Suite
--------------------
1. First make a copy of files `robot_variables_template.py` to your home user folder and remove the `template` suffix.
1. File `robot_variables` has all initial variables to run RF and you have to change to fit your machine settings as needed, since it will be ignored by Git anyway as each automation developer can have different settings: 
    * `SELENIUM_SERVER = "127.0.0.1"` - Selenium Grid Server IP Address. If you want to run the tests locally, then remove or leave this variable empty.
    * `SELENIUM_PORT = "4444"` - Default Selenium Grid Server port. Usually there won't be needed to change this.
    * `BROWSER = "chrome"`
        Which browser you want to run the tests. The available options are: `chrome` (Google Chrome, Microsoft Edge 2020, Opera), `firefox`, `webkit` (Apple Safari, Mail, AppStore on MacOS and iOS). Default is `chrome`, other browsers were not tested.
    * `TIMEOUT = "30s"`  
        Regular timeout that applies to most keywords. If this time is exceeded the test fails. You can *eventually* increase this time when the environment slowness reason is known.

1. To run the script locally, outside the Docker container:
    * To run the full test suite on another Git Bash / terminal window, activate the Python Virtual Environment as stated before and use this command:
    ```
    (env) $ robot --variablefile ~/robot_variables.py --loglevel TRACE --outputdir results ./tests/
    ```
    * To run specific tests only, after `--include` parameter, add the TAG of the test case you want to run. You can add more `--include` parameters to run other tests. You can also use logical operators (AND, OR and NOT) to select the tests, like `--include demoORmy-test-tag`, this will run any tests that have at least one of the tags. Using `--include demoNOTmy-test-tag` will run all tests with the first tag except the tests with the second tag. And with `--include demoANDmy-test-tag` will run tests that have BOTH tags. You can achieve the same result as OR operator by adding `--exclude` option and the test tag.
    ```
    (env) $ robot --variablefile ~/robot_variables.py --loglevel TRACE --outputdir results --include [MyTestTag] ./tests/    
    ```
    * Option `--variablefile` simply points to your local copy of `robot_variables.py`.
    * Set `--loglevel` option to `TRACE` when running locally for debugging, but in automation production running environment this should be set to `INFO` to save resources.
    * `--outputdir` refers to where RF should save the report after finishing the execution. Can be `logs*` or `results*` folder names, as both are already ignored in Git.
1. To run the script in the container, first you need to setup the proper user on WSL distro to match the user on Docker container:
    * Create the docker user group, usually it is created during Docker installation:  
        `$ sudo groupadd docker`
    * Then run this commando to add the currently logged in user to the docker group:  
        `$ sudo usermod -aG docker ${USER}`
    * Verify you can run docker without sudo:  
        `$ docker run hello-world`
    * Add pwuser to docker group:
        `$ sudo usermod -aG docker pwuser`
    * Build the Docker image by running:  
    `$ docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t [IMAGE_NAME]:1.0 resources/docker/`  
    The tag after `:` can be changed to create different image versions. Avoid running the same command again using the same image tag. Delete the old image before with `$ docker rmi [IMAGE_ID]`, where you can get the image ID with `$ docker image list`.
    * Usually in CI/CD pipeline a single docker run command must be used to bring the container up and trigger the script, but for script development process is better to split in two steps: one command to start the container and another to run the script.
    Command to bring the container up:  
    `$ docker run -d --rm -it -v $(pwd):/home/[PATH_TO]/robot -p 5900:5900 [IMAGE_NAME]:1.0`  
    The command to run a test suite is pretty similar to the one explained earlier in this guide:  
    `$  docker exec -it [CONTAINER_ID] bash -c "robot --variablefile robot_variables.py --loglevel TRACE --outputdir results --include [TEST_TAGS] ./tests/"`  
    You just need to replace `[TEST_TAGS]` with the tags you want to run and get the ID of the container using `$ docker ps`. Also you can replace `[CONTAINER_ID]` to `$(docker ps -aq)` to get the container ID directly in the same command, as long as you have *only one* container running at the moment.
    * After the test is finished, you can view the report opening this default path on you browser on Windows, considering you are using Ubuntu 20.04 distro: `\\wsl$\Ubuntu-20.04\home\[USERNAME]\[AUTOMATION_PATH]\results\report.html`.  
# Useful Links
- [Robot Framework User Guide](http://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html)
- [Built In Keywords](http://robotframework.org/robotframework/latest/libraries/BuiltIn.html)
- [SeleniumLibrary Keywords](https://robotframework.org/SeleniumLibrary/SeleniumLibrary.html)
- [Git Tutorial](https://testautomationu.applitools.com/git-tutorial/)
