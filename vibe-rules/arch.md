# 项目架构

## 1. 目录结构

```
/
├── data/
│   ├── raw/                # 原始数据
│   ├── processed/          # 处理后的数据
│   └── interim/            # 中间数据
├── notebooks/              # Jupyter notebooks
├── src/
│   ├── __init__.py
│   ├── datasets/           # 数据集加载
│   │   └── __init__.py
│   ├── utils/              # 通用工具函数
│   │   └── __init__.py
│   ├── metrics/            # 评估指标
│   │   └── __init__.py
│   ├── models/             # 模型定义
│   │   └── __init__.py
│   └── engine/             # 训练和评估引擎
│       └── __init__.py
├── scripts/                # 任务脚本
├── tools/                  # 独立小工具
├── tests/                  # 测试
├── configs/                # 配置文件
│   └── config.yaml
├── requirements.txt        # 依赖
├── setup.py                # 项目安装脚本
└── README.md               # 项目说明
```

## 2. 模块说明

- **`data/`**: 存储所有数据。
    - `raw/`: 不可更改的原始数据。
    - `processed/`: 清洗和处理后的最终数据，可用于模型训练。
    - `interim/`: 数据转换过程中的中间文件。
- **`notebooks/`**: 用于探索性数据分析（EDA）和原型设计的 Jupyter Notebooks。文件名应以数字开头，以反映分析的顺序（例如 `01-initial-exploration.ipynb`）。
- **`src/`**: 主要源代码。
    - `datasets/`: 数据集加载和处理。
    - `utils/`: 通用工具函数。
    - `metrics/`: 评估指标。
    - `models/`: 模型定义。
    - `engine/`: 训练和评估引擎。
- **`scripts/`**: 存放一些执行特定任务的脚本 (例如, 数据下载, 模型训练)。
- **`tools/`**: 存放一些独立的小工具。
- **`tests/`**: 单元测试和集成测试。
- **`configs/`**: 存储项目配置，如超参数、文件路径等。
- **`requirements.txt`**: 项目的 Python 依赖项。