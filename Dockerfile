FROM node:16-alpine3.15
RUN mkdir /elyasapi
WORKDIR /elyasapi
COPY package.json /elyasapi
RUN npm i
COPY . /elyasapi

# COPY oic.zip  /tmp
RUN apk --no-cache add libaio libnsl libc6-compat curl unzip && \
#     cd /tmp && \
    curl -o instantclient-basiclite.zip https://download.oracle.com/otn_software/linux/instantclient/instantclient-basiclite-linuxx64.zip -SL && \
    unzip instantclient-basiclite.zip && \
#     unzip oic.zip && \
    mv instantclient*/ /usr/lib/instantclient && \
#     rm oic.zip && \
    ln -s /usr/lib/instantclient/libclntsh.so.21.1 /usr/lib/libclntsh.so && \
    ln -s /usr/lib/instantclient/libocci.so.21.1 /usr/lib/libocci.so && \
    ln -s /usr/lib/instantclient/libociicus.so /usr/lib/libociicus.so && \
    ln -s /usr/lib/instantclient/libnnz21.so /usr/lib/libnnz21.so && \
    ln -s /usr/lib/libnsl.so.2 /usr/lib/libnsl.so.1 && \
    ln -s /lib/libc.so.6 /usr/lib/libresolv.so.2 && \
    ln -s /lib64/ld-linux-x86-64.so.2 /usr/lib/ld-linux-x86-64.so.2

ENV LD_LIBRARY_PATH /usr/lib/instantclient
EXPOSE 9010
CMD exec node app_elyasapi.js
