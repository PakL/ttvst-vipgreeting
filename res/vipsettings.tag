<vipsettings>
	<vip each="{ vip in vips }" no-reorder key="{ vip.key }" vip="{ vip }"></vip>
	<button onclick="{ addavip }" ref="addbutton"></button>

	<style>
		vipsettings {
			display: block;
		}
	</style>
	<script>
		const self = this
		this.vips = []
		this.vipaddon = opts.addon

		this.highestKey = 1

		loadVIPs() {
			self.vips = []
			self.vips = self.vipaddon.settings.getJSON('vipsettings', [])
			self.vips.forEach((v, i) => {
				if(!v.hasOwnProperty('key'))
					self.vips[i].key = self.getNextHighestKey()
			})
			self.vipaddon.vipsettings = self.vips
			self.update()
		}

		this.on('mount', () => {
			self.refs.addbutton.innerText = Tool.addons.getAddon('vipgreeting').i18n.__('Add VIP')
			self.loadVIPs()
		})

		getNextHighestKey() {
			let usedVipKeys = []
			self.vips.forEach((v, i) => {
				if(!v.hasOwnProperty('key')) return
				usedVipKeys.push(v.key)
			})
			while(usedVipKeys.indexOf(self.highestKey) >= 0) {
				self.highestKey++
			}
			return self.highestKey
		}

		addavip() {
			self.vips.push({ key: self.getNextHighestKey(), user: '', file: '', volume: 0.5 })
			self.update()
		}
		savevips() {
			let data = []
			let vips = self.root.querySelectorAll('vip')
			vips.forEach((v) => {
				console.log(v)
				let username = v.querySelector('.username > input')
				let filename = v.querySelector('.filename > input')
				let volume = v.querySelector('.volumeslider > input')
				let key = v.querySelector('input.key')
				if(username !== null && filename !== null && volume !== null && key !== null) {
					if(parseInt(key.value) == NaN || parseInt(key.value) <= 0) return
					data.push({key: parseInt(key.value), user: username.value.toLowerCase(), file: filename.value, volume: volume.value})
				}
			})
			self.vipaddon.settings.setJSON('vipsettings', data)
			self.loadVIPs()
		}
	</script>
</vipsettings>