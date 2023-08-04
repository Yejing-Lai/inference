#!/bin/bash
# This example will start serving the 175B model.
# DISTRIBUTED_ARGS="--nproc_per_node 8 \
#                   --nnodes 1 \
#                   --node_rank 0 \
#                   --master_addr localhost \
#                   --master_port 6000"

DISTRIBUTED_ARGS=" --num_nodes 1 --num_gpus 8"
CHECKPOINT=/media/newdrive2/gpt3-checkpoint
TOKENIZER_MODEL_FILE=/home/yejingla/Workspace/mlperf_gpt3_infer/inference/language/gpt3/megatron/data/c4_en_301_5Mexp2_spm.model

export CUDA_DEVICE_MAX_CONNECTIONS=1

pip install flask-restful

deepspeed $DISTRIBUTED_ARGS text_generation_server.py   \
       --tensor-model-parallel-size 8  \
       --pipeline-model-parallel-size 1  \
       --num-layers 96  \
       --hidden-size 12288  \
       --num-attention-heads 96  \
       --max-position-embeddings 2048  \
       --tokenizer-type SentencePieceTokenizer  \
       --micro-batch-size 1  \
       --seq-length 2048  \
       --tokenizer-model $TOKENIZER_MODEL_FILE \
       --seed 42  \
       --no-load-rng  \
       --fp16  \
       --use-beam-search  \
       --ds-inference
       # --load ${CHECKPOINT} \