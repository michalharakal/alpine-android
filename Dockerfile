FROM frolvlad/alpine-glibc:alpine-3.6

RUN apk add --no-cache \
  openjdk8 \
  bash \
  unzip

ENV JAVA8_HOME /usr/lib/jvm/java-1.8-openjdk
ENV JAVA_HOME $JAVA8_HOME
ENV PATH $PATH:$JAVA_HOME/bin

ENV ANDROID_SDK_FILE sdk-tools-linux-3859397.zip
ENV ANDROID_SDK_URL http://dl.google.com/android/repository/${ANDROID_SDK_FILE}
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools

RUN mkdir -p ${ANDROID_HOME} && cd ${ANDROID_HOME} && \
  echo "Wget'ing ${ANDROID_SDK_URL} ..." && \
  wget -q ${ANDROID_SDK_URL}
RUN cd ${ANDROID_HOME} && unzip ${ANDROID_SDK_FILE} && \
  rm ${ANDROID_SDK_FILE}
RUN mkdir -p ${ANDROID_HOME}/licenses && \
  echo "8933bad161af4178b1185d1a37fbf41ea5269c55" > ${ANDROID_HOME}/licenses/android-sdk-license && \
  echo "84831b9409646a918e30573bab4c9c91346d8abd" > ${ANDROID_HOME}/licenses/android-sdk-preview-license
RUN echo y | sdkmanager --channel=3 --no_https tools platform-tools \
    "platforms;android-26" \
    "build-tools;26.0.1" \
    "extras;google;m2repository" && \
  sdkmanager --uninstall emulator
RUN mkdir -p ~/.gradle && echo "org.gradle.daemon=false" >> ~/.gradle/gradle.properties
