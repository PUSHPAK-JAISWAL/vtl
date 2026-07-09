// vtest retry: 3
module datasets

fn test_mnist() {
	unbuffer_stdout()
	println('start')
	mnist := load_mnist() or {
		if is_transient_mnist_download_error(err.msg()) {
			eprintln('skipping MNIST download-dependent test after transient error: ${err.msg()}')
			return
		}
		assert false, err.msg()
		return
	}
	println('mnist dataset loaded')

	assert mnist.train_features.shape == [60000, 28, 28]
	assert mnist.test_features.shape == [10000, 28, 28]
	assert mnist.train_labels.shape == [60000]
	assert mnist.test_labels.shape == [10000]
	println('done')
}

fn is_transient_mnist_download_error(message string) bool {
	transient_markers := [
		'Gateway Time-out',
		'Gateway Timeout',
		'request timed out',
		'connection reset',
		'connection refused',
		'connection timed out',
		'temporary failure',
		'no such host',
		'unexpected EOF',
	]
	for marker in transient_markers {
		if message.contains(marker) {
			return true
		}
	}
	return false
}
