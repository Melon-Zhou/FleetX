set -x

export PYTHONPATH=./atarashi/:$PYTHONPATH


export PADDLE_WITH_GLOO=0
export GLOG_v=1
export NCCL_DEBUG=INFO
export FLAGS_call_stack_level=2
export FLAGS_allocator_strategy=naive_best_fit

rm -rf *.prototxt
rm -rf core.*

task_name='gpt3-230B-32pp4dp2mp'
output_dir=output/${task_name}
rm -rf ${output_dir}

python -m paddle.distributed.fleet.launch \
	--log_dir ${output_dir}/log \
run_pretraining.py \
	--global_bsz 64 \
	--micro_bsz 1 \
	--max_seq_len 512 \
	--ernie_config_file config/ernie_base_config.json \
	--learning_rate 1e-4 \
	--log_steps 1 \
	--num_train_steps 1000000 \
	--save_steps 100000 \
	--output_dir ${output_dir} \
	--use_recompute true \
	--use_sharding true \
	--use_sop false \
	--num_mp=4 \
	--num_sharding=2 \
	--num_pp=2 \
	--num_dp=1 \

