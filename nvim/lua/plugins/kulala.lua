return {
	"mistweaverco/kulala.nvim",
	ft = { "http", "rest" },
	keys = {
		{ "<leader>Rs", "<cmd>lua require('kulala').run()<cr>", desc = "发送请求" },
		{ "<leader>Ra", "<cmd>lua require('kulala').run_all()<cr>", desc = "发送所有请求" },
		{ "<leader>Rp", "<cmd>lua require('kulala').jump_prev()<cr>", desc = "上一个请求" },
		{ "<leader>Rn", "<cmd>lua require('kulala').jump_next()<cr>", desc = "下一个请求" },
		{ "<leader>Ri", "<cmd>lua require('kulala').inspect()<cr>", desc = "查看请求详情" },
		{ "<leader>Rc", "<cmd>lua require('kulala').copy()<cr>", desc = "复制为 curl" },
		{ "<leader>Rq", "<cmd>lua require('kulala').close()<cr>", desc = "关闭结果窗口" },
	},
	opts = {
		default_view = "body",
		default_env = "dev",
		debug = false,
	},
}
