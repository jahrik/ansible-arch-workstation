local conf = {
  "conf.set",
  "conf.remap",
  "conf.plugins"
}

for i = 1, #conf do
  local ok, err = pcall(require, conf[i])
  if not ok then
    print(err)
  end
end
