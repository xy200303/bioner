# 使用更精简的CUDA基础镜像，并明确指定CUDA 12.8版本
FROM pytorch/pytorch:2.9.1-cuda12.6-cudnn9-runtime

LABEL maintainer1="3483421977@qq.com"
LABEL version="0.1.fix"
LABEL description="Bio-NLP"
LABEL author="xiaoyun"

EXPOSE 5000

# 设置环境变量和时区，减少交互式提示
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
ENV SOLR_URL="http://librairy.linkeddata.es/solr/"

# 如果网络连接需要，可以设置PyPI镜像源，例如：
RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

# 根据PyTorch官方指南，安装与CUDA 12.8兼容的PyTorch[1,4](@ref)
# 这个版本是预编译好的，包含了必要的CUDA运行时，无需完整Toolkit

# 先复制依赖文件并安装，利用Docker缓存层
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 安装spacy的英语模型
RUN python3 -m spacy download en_core_web_sm

# 复制应用代码
COPY app.py /app/
COPY models/ /app/models/
COPY bionlp/ /app/bionlp/
COPY templates /app/templates/
COPY static /app/static/

WORKDIR /app

ENTRYPOINT ["python3"]
CMD ["app.py"]