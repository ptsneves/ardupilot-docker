FROM alpine:3.6
MAINTAINER Paulo Neves <info@airborneprojects.com>

RUN apk update && apk add --no-cache \
  git \
  gcc \
  g++ \
  python \
  py-pip \
  ccache
  socat \
  bash \
  util-linux


RUN pip install pip \
    future

RUN git clone git://github.com/Ardupilot/ardupilot.git ardupilot
WORKDIR "/ardupilot"
RUN git fetch --all --tags --prune
RUN git checkout tags/Copter-3.5.5
RUN git submodule update --init --recursive
RUN \
  sed -i 's|feenableexcept(exceptions);|//feenableexcept(exceptions);|' /ardupilot/libraries/AP_HAL_SITL/Scheduler.cpp && \
  sed -i 's|int old = fedisableexcept(FE_OVERFLOW);|int old = 1;|' /ardupilot/libraries/AP_Math/matrix_alg.cpp && \
  sed -i 's|if (old >= 0 && feenableexcept(old) < 0)|if (0)|' /ardupilot/libraries/AP_Math/matrix_alg.cpp && \
  sed -i "s|#include <sys/types.h>|#include <sys/types.h>\n\n#define TCGETS2 _IOR('T', 0x2A, struct termios2)\n#define TCSETS2 _IOW('T', 0x2B, struct termios2)|" /ardupilot/libraries/AP_HAL_SITL/UARTDriver.cpp
RUN \
  ./waf configure --board sitl  && \
  ./waf all

EXPOSE 5760
ENTRYPOINT ["socat"]
COPY ardupilot-server.sh /usr/bin/ardupilot-server
CMD ["tcp-l:5760,fork", "EXEC:'/usr/bin/ardupilot-server',pty,setsid,ctty,sighup,sigint,sigquit"]
