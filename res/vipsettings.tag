<vipsettings>
	<vip each={ vip in vips } no-reorder vip={ vip }></hotkey>

	<style>
		vipsettings {
			display: block;
		}
	</style>
	<script>
		const self = this
		this.vips = []
		this.vipaddon = opts.addon

		loadVIPs() {
			self.vips = self.vipaddon.settings.getJSON('vipsettings', [])
			self.vipaddon.vipsettings = self.vips
			self.update()
		}

		this.on('mount', () => {
			self.loadVIPs()
		})

		addavip() {
			self.vips.push({ user: '', file: '' })
			self.update()
		}
		savevips() {
			let data = []
			let vips = self.root.querySelectorAll('vip')
			vips.forEach((v) => {
				let username = v.querySelector('.username > input')
				let filename = v.querySelector('.filename > input')
				if(username !== null && filename !== null) {
					data.push({user: username.value.toLowerCase(), file: filename.value})
				}
			})
			self.vipaddon.settings.setJSON('vipsettings', data)
			self.loadVIPs()
		}
	</script>
</vipsettings>