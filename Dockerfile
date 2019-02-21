FROM        ubuntu:xenial

ENV         DEBIAN_FRONTEND=noninteractive \
            VSC_DL_URL=https://go.microsoft.com/fwlink/?LinkID=760868

ENV         DISPLAY=:1 \
            VNC_PORT=5901 \
            NO_VNC_PORT=6901

RUN         apt-get update && \
            apt-get install -y \
                openssl \
                nodejs \
                npm \
                git \
                wget \
                libgtk2.0 \
                libgconf-2-4 \
                libasound2 && \
                git && \
            npm install -g typescript

RUN         apt-get install -y firefox sudo x11vnc xvfb

RUN         wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN         dpkg -i google-chrome-stable_current_amd64.deb; apt-get -fy install

ENV         HOME=/home/code

RUN         wget -O /tmp/vsc.deb $VSC_DL_URL && \
            apt install -y /tmp/vsc.deb && \
            rm -f /tmp/vsc.deb && \
            useradd --user-group --create-home --home-dir $HOME code | chpasswd && adduser code sudo && \
            mkdir -p $HOME/.vscode/extensions $HOME/.config/Code/User && \
            touch $HOME/.config/Code/storage.json && \
            chown -R code:code $HOME

RUN         echo 'code ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers && \
            cat /etc/sudoers && \
            echo 'code:123456' | chpasswd

RUN         wget -O $HOME/vsls-reqs https://aka.ms/vsls-linux-prereq-script && chmod +x $HOME/vsls-reqs && $HOME/vsls-reqs

COPY        entry-point-headless /usr/bin/entry-point-headless
RUN         chmod +x /usr/bin/entry-point-headless
COPY        entry-point /usr/bin/entry-point
RUN         chmod +x /usr/bin/entry-point
COPY        entry-point /usr/bin/entry-point-shell
RUN         chmod +x /usr/bin/entry-point-shell

EXPOSE      $VNC_PORT $NO_VNC_PORT

RUN         bash -c 'echo "firefox" >> /.bashrc' && \
            bash -c 'echo "code" >> /.bashrc'

USER        code

RUN         mkdir $HOME/.vnc && \
            chown -R code:code /home/code/.vnc && \
            x11vnc -storepasswd 1234 $HOME/.vnc/passwd && \
            chown code:code /home/code/.vnc/passwd

WORKDIR     $HOME/mount
ENTRYPOINT  [ "/usr/bin/entry-point-headless" ]
