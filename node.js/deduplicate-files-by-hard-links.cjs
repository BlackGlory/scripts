#!/usr/bin/env node
// 以创建硬链接的方式去除重复文件
// 使用方法: node deduplicate-files-by-hard-links.cjs <input
// 输入格式为以行作为分隔符的哈希文件路径对: "hash:filename"

const fs = require('fs-extra')
const readline = require('readline')
const { getError } = require('return-style')

const hashToFilename = {}
const pendingList = []
const rl = readline.createInterface({ input: process.stdin })

rl.on('line', line => {
  const [hash, filename] = splitFirst(line, ':')
  if (hash in hashToFilename) {
    pendingList.push(hardlink(hashToFilename[hash], filename))
  } else {
    hashToFilename[hash] = filename
  }
})

rl.on('close', async () => {
  for (const promise of pendingList) {
    if (await getError(promise)) console.error(err)
  }
})

function splitFirst(str, seq) {
  const [first, ...others] = str.split(seq)
  return [first, others.join(seq)]
}

async function hardlink(existFilename, newFilename) {
  if (await fs.pathExists(newFilename)) {
    await fs.unlink(newFilename)
  }
  await fs.link(existFilename, newFilename)
}
