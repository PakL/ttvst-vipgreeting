<vipsettings>
	<vip each={ vip in vips } key={ vip.key } vip={ vip }></vip>
	<button onclick={ addavip } ref="addbutton"></button>

	<style>
		vipsettings {
			display: block;
		}
	</style>
	<script>
		export default {
			
			onBeforeMount() {
				this.vips = []
				this.vipaddon = this.props.addon

				this.highestKey = 1
				this.makeAccessible()
			},

			onMounted() {
				this.refs = {
					addbutton: this.$('[ref=addbutton]')
				}

				this.refs.addbutton.innerText = this.vipaddon.i18n.__('Add VIP')
				this.loadVIPs()
			},

			loadVIPs() {
				this.vips = []
				this.update()
				this.vips = this.vipaddon.settings.getJSON('vipsettings', [])
				this.vips.forEach((v, i) => {
					if(!v.hasOwnProperty('key'))
						this.vips[i].key = this.getNextHighestKey()
				})
				this.vipaddon.vipsettings = this.vips
				this.update()
			},

			getNextHighestKey() {
				let usedVipKeys = []
				this.vips.forEach((v, i) => {
					if(!v.hasOwnProperty('key')) return
					usedVipKeys.push(v.key)
				})
				while(usedVipKeys.indexOf(this.highestKey) >= 0) {
					this.highestKey++
				}
				return this.highestKey
			},

			addavip() {
				this.vips.push({ key: this.getNextHighestKey(), user: '', file: '', volume: 0.5 })
				this.update()
			},
			savevips() {
				let data = []
				let vips = this.root.querySelectorAll('vip')
				vips.forEach((v) => {
					let username = v.querySelector('.username > input')
					let filename = v.querySelector('.filename > input')
					let volume = v.querySelector('.volumeslider > input')
					let key = v.querySelector('input.key')
					if(username !== null && filename !== null && volume !== null && key !== null) {
						if(parseInt(key.value) == NaN || parseInt(key.value) <= 0) return
						data.push({key: parseInt(key.value), user: username.value.toLowerCase(), file: filename.value, volume: volume.value})
					}
				})
				this.vipaddon.settings.setJSON('vipsettings', data)
				this.loadVIPs()
			}
		}
	</script>
</vipsettings>