FROM kalilinux/kali-rolling as build

ARG DEBIAN_FRONTEND=noninteractive

COPY ./bin/* /var/teamhack/bin/
ENV PATH=/var/teamhack/bin:$PATH

RUN apt update                     \
&&  apt full-upgrade -y            \
    --no-install-recommends        \
&&  apt install      -y            \
    --no-install-recommends        \
    aircrack-ng                    \
    ncat                           \
&&  apt autoremove   -y            \
    --purge                        \
&&  apt clean        -y            \
&&  rm -rf /var/lib/apt/lists/*    \
&&  test -x /usr/bin/env           \
&&  command -v ncat                \
&&  command -v aircrack-ng.lst.sh  \
&&  command -v cap-recv.sh

#RUN mkdir -pv /var/teamhack/upload

WORKDIR  /var/teamhack
VOLUME ["/var/teamhack/caps"]
VOLUME ["/var/teamhack/psks"]
ENV TEAMHACK_DOCKER=1
ENTRYPOINT [                                        \
  "/usr/bin/env",                                   \
  "ncat",                                           \
  "--source-port", "43415",                         \
  "--exec",        "bin/cap-recv.sh",               \
  "--listen",                                       \
  "--keep-open"                                     \
]
CMD [                                               \
  "-4",                                             \
  "--nodns",                                        \
  "--verbose"                                       \
]

expose 43415/tcp

