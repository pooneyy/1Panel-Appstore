# MT Photos AI 识别相关任务独立部署项目

- 基于PaddleOCR实现的文本识别(OCR)接口
- 基于Chinese-CLIP（OpenAI CLIP模型的中文版本）实现的图片、文本提取特征接口

## devfox101 版

- `devfox101/mt-photos-ai`
  合并了 `mt-photos-ai` 和 `mt-photos-insightface-unofficial` 2 个镜像的代码,运行这一个镜像就可以支持以上 2 个镜像的功能

- 如果在添加智能识别 API 和人脸识别 API 时，需要调用 Intel 核显来加速处理；可以使用 devfox101/mt-photos-ai 镜像，并给容器映射/dev/dri

```yml
devices:
  - "/dev/dri:/dev/dri"
```