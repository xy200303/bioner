# 医药、基因和化学物品命名实体识别
本项目基于https://github.com/librairy/bio-ner，主要修复了部分依赖过旧导致项目无法运行的问题，非常感谢原作者开发了如此优秀的项目。
原项目基于python3.6开发，所依赖的库版本较旧，且不支持cuda11.6及以上版本，使用的pytorch版本也较旧。本项目重新构建了适用于python3.11及以上版本、支持cuda12.6的环境，以支持在4090系列GPU上进行推理。
如果您希望使用较低版本的python依赖，可以前往原项目查看使用。

### 基于Docker的一键化部署
1. 创建容器网络。这是为了将solr和主体项目放在同一个局域网环境下，使得主体项目可以调用solr进行数据查询。

`docker network create bioner-network`

2. 下载并运行主体项目bioner

`docker run --name bioner --network bioner-network -it -p 127.0.0.1:5000:5000 -e SOLR_URL="http://bioner-solr:8983/solr/" xy200303/bioner:latest`

3. 下载并启动运行solr服务器

`docker run --name bioner-solr --network bioner-network -it -p 8983:8983 xy200303/solr-bioner:latest`

4. 进入solr服务器，初始化数据

`docker exec -it bioner-solr bash`

`cd /app`

`bash init.sh`

## 网页界面
访问地址: https://librairy.github.io/bio-ner/.

<p align="center">
<img src="https://user-images.githubusercontent.com/72864707/120455069-bab60800-c394-11eb-9c41-c2aeefc4f7cc.png" align="center" width="70%">
</p>

网页界面允许轻松使用该系统，只需粘贴要处理的文本并点击分析按钮。这些数据将通过AJAX调用发送到系统，系统将返回在以下视图中标注和归一化的数据：

### 结果标注
标注结果将以彩色框表示，其中每个框代表一个实体类别。

<p align="center">
<img src="https://user-images.githubusercontent.com/72864707/120455516-20a28f80-c395-11eb-97a8-fb54b017eaab.png" align="center" width="70%">
</p>

### 结果归一化
归一化结果将以表格形式呈现每个实体类别。将检索出找到的术语以及存储在Solr数据库中的ID。如果在处理的文本中出现与https://www.covid19dataportal.org/biochemistry?db=opentargets 或https://proconsortium.org/cgi-bin/textsearch_pro?search=search&field0=ALLFLDS&query0=ncbitaxon%3A2697049 相关的COVID术语，将出现一个额外的表格。

<p align="center">
<img src="https://user-images.githubusercontent.com/72864707/120455588-3021d880-c395-11eb-965a-6c96bea89265.png" align="center">
</p>
	
### JSON格式结果
为了便于后续使用检索到的信息，还提供了一个Json文本框。

<p align="center">
<img src="https://user-images.githubusercontent.com/72864707/120455619-36b05000-c395-11eb-9522-14f3f4117017.png" align="center" width="70%">
</p>

## CORD-19标注
所提出的系统将用于一个实际案例：CORD-19语料库的标注，该语料库包含数千篇COVID-19相关文章。为此，语料库将进行预处理，分割成段落，并使用 https://github.com/librairy/cord-19 加载到Solr数据库中。
为了方便使用此标注功能，推荐使用其容器化版本。此Docker镜像在Docker Hub上的仓库地址为：https://hub.docker.com/r/alvaroalon2/bionlp_cord19_annotation。Docker镜像包含了镜像内的模型。如果不想使用提供的在线Solr数据库端点'http://librairy.linkeddata.es/solr/'，则不应在`docker run`命令中传递环境变量。

### GPU支持
在具有NVIDIA GPU的Docker容器内进行GPU支持需要https://github.com/NVIDIA/nvidia-docker。运行容器并初始化其标注和归一化的步骤如下：
1. `docker pull alvaroalon2/bionlp_cord19_annotation:gpu`
2. `docker run --name annotation -it --gpus all --network 'host' -e SOLR_URL="http://librairy.linkeddata.es/solr/" alvaroalon2/bionlp_cord19_annotation:gpu`

### CPU支持
如果没有可用的GPU，也可以在CPU上进行部署。标注速度会显著变慢。如果是这种情况，建议使用CPU版本的Docker镜像而不是GPU版本：
1. `docker pull alvaroalon2/bionlp_cord19_annotation:cpu`
2. `docker run --name annotation -it --network 'host' -e SOLR_URL="http://librairy.linkeddata.es/solr/" alvaroalon2/bionlp_cord19_annotation:cpu`

## 模型
针对每个实体类别（疾病、化学品、遗传物质）提出了一个模型。因此，最终系统由三个模型组成，每个模型负责对其对应的实体类别进行标注。系统会自动检查模型是否已存储在其对应的https://github.com/librairy/bio-ner/tree/master/models 中。如果缺少模型，系统会自动从其对应的Huggingface仓库下载缓存的版本，我们提出的模型已上传至该仓库。以下是所提出模型的仓库地址：
* 疾病: https://huggingface.co/alvaroalon2/biobert_diseases_ner
* 化学品: https://huggingface.co/alvaroalon2/biobert_chemical_ner
* 遗传物质: https://huggingface.co/alvaroalon2/biobert_genetic_ner

更多详细信息请参见: https://github.com/alvaroalon2/bio-nlp/tree/master/models。如果需要，这些模型可用于其他系统。

### 微调
微调过程是在Google Colab上使用TPU完成的。为此，我们提供了https://github.com/librairy/bio-ner/blob/master/fine-tuning/Fine_tuning.ipynb Jupyter笔记本，它使用了 https://github.com/librairy/bio-ner/blob/master/fine-tuning/ 中的脚本，这些脚本部分改编自 https://github.com/dmis-lab/biobert-pytorch 中最初提出的脚本，以便允许TPU执行和使用更新版本的huggingface-transformers。

## 嵌入可视化
关于可视化的详细信息以及一个示例，请参见 https://github.com/librairy/bio-ner/tree/master/Embeddings。