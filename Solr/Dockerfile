# 使用官方 Solr 镜像
FROM solr:8.11.2

# 设置 Solr 主目录环境变量
ENV SOLR_HOME=/var/solr/data

EXPOSE 8983
# 切换到 root 用户来执行构建时的操作

# 复制当前目录下的 data 文件夹到容器的工作目录
COPY ./data_processing /app/data_processing/
COPY ./create_schemas.sh /app/create_schemas.sh
COPY ./index_docs.sh /app/index_docs.sh
COPY ./init.sh /app/init.sh

# 创建数据目录（使用 root 权限）
RUN mkdir -p /var/solr/data

# 创建所有需要的核心
RUN /opt/docker-solr/scripts/precreate-core bioner-drugs && \
    /opt/docker-solr/scripts/precreate-core bioner-diseases && \
    /opt/docker-solr/scripts/precreate-core bioner-genetic && \
    /opt/docker-solr/scripts/precreate-core bioner-covid


# 设置启动命令
# 使用 exec 形式确保信号正确传递
CMD ["solr-foreground"]