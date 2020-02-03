FROM ubuntu:18.04
RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    gcc \
    make \
    libssl-dev \
    zlib1g-dev \
    libmysqlclient-dev \
    redis-server \
    libsqlite3-dev \
    nano \
    nodejs \
    imagemagick \
    zsh
RUN apt-get install -y wget
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
ARG TZ=Europe/Paris
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get install -y \
    build-essential \
    tklib \
    zlib1g-dev \ 
    libssl-dev \
    libffi-dev \
    libxml2 \
    libxml2-dev \ 
    libxslt1-dev \
    libreadline-dev
RUN apt-get clean
RUN git clone https://github.com/rbenv/rbenv.git ~/.rbenv
RUN git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
RUN /root/.rbenv/plugins/ruby-build/install.sh
ENV PATH /root/.rbenv/bin:$PATH
RUN echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh # or /etc/profile
RUN echo 'eval "$(rbenv init -)"' >> .zshrc
RUN rbenv install 2.6.2
RUN rbenv global 2.6.2
WORKDIR /root
RUN echo '#!/bin/zsh' >> .zshrc
RUN chmod 700 .zshrc
RUN /usr/bin/zsh .zshrc
RUN echo 'eval "$(rbenv init -)"' >> .zprofile
#RUN echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p
#RUN curl -Ls https://raw.githubusercontent.com/lewagon/setup/master/check.rb > _.rb && ruby _.rb || rm _.rb
RUN eval "$(rbenv init -)" && gem install rake bundler rspec rubocop rubocop-performance pry pry-byebug hub colored octokit
RUN apt-get install -y postgresql postgresql-contrib libpq-dev build-essential
RUN adduser mailoop-dev
#RUN usermod -aG sudo mailoop-dev
#RUN su - postgres && psql
#RUN su -mailoop-dev /usr/lib/postgresql/10/bin/pg_ctl -D /var/lib/postgresql/10/main -l logfile start
#RUN postgres psql --command "CREATE ROLE postgres LOGIN createdb;"
ENTRYPOINT [ "/usr/bin/zsh", "--login" ]
